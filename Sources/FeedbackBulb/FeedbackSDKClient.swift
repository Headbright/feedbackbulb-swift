import Foundation
import MultipartKit

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct FeedbackSDKClient {
  /// The URL of the instance we're connected to
  public var instanceURL: URL
  /// Set this to `true` to see a logger output of outgoing requests.
  public var debugRequests: Bool = false
  /// Set this to `true` to see a logger output of request response.
  public var debugResponses: Bool = false
  /// Set this to `true` to see a logger outputfor instance information.
  public var debugInstance: Bool = false
  /// Application key associated with this client instance
  public let appKey: String
  internal var decoder: JSONDecoder = FeedbackSDKDecoder()
  internal var encoder: JSONEncoder = FeedbackSDKEncoder()
  internal var session: URLSession
  internal let validStatusCodes = 200..<300

  public init(
    appKey: String,
    session: URLSession = URLSession.shared,
    instanceURL: URL
  ) {
    self.session = session
    self.instanceURL = instanceURL
    self.appKey = appKey
  }

  /// Prints extra debug details like outgoing requests and responses
  public mutating func debugOn() {
    self.debugRequests = true
    self.debugResponses = true
    self.debugInstance = true
  }

  /// Stops printing debug details
  public mutating func debugOff() {
    self.debugRequests = false
    self.debugResponses = false
    self.debugInstance = false
  }
}

// MARK: - Encoding/Decoding and fetching data
extension FeedbackSDKClient {

  internal func decode<T: Decodable>(_ decodable: T.Type, from data: Data) throws -> T {
    do {
      return try decoder.decode(decodable, from: data)
    } catch {
      let description = fetchError(T.self, data: data)

      if debugResponses {
        zofxLogger.debug("\(description)")
      }

      throw FeedbackSDKError.decodingError(description)
    }
  }

  /// Fetch data asynchronously and return the decoded `Decodable` object.
  internal func fetch<T: Decodable>(_ decode: T.Type, _ req: HTTPRequestBuilder) async throws -> T {
    let (data, _) = try await fetch(req: req)

    do {
      return try decoder.decode(decode, from: data)
    } catch {
      let description = fetchError(T.self, data: data)

      if debugResponses {
        zofxLogger.debug("\(description)")
      }

      throw FeedbackSDKError.decodingError(description)
    }
  }

  private func fetchError<T: Decodable>(_ decode: T.Type, data: Data) -> String {
    var description: String = "Unknown decoding error"

    do {
      _ = try decoder.decode(decode, from: data)
    } catch DecodingError.dataCorrupted(let context) {
      description = "context: \(context)"
    } catch DecodingError.keyNotFound(let key, let context) {
      description =
        "Key '\(key)' not found:\(context.debugDescription)\n codingPath:\(context.codingPath)"
    } catch DecodingError.valueNotFound(let value, let context) {
      description =
        "Value '\(value)' not found:\(context.debugDescription)\n codingPath:\(context.codingPath)"
    } catch DecodingError.typeMismatch(let type, let context) {
      description =
        "Type '\(type)' mismatch:\(context.debugDescription)\n codingPath:\(context.codingPath)"
    } catch {
      description = error.localizedDescription
    }

    return description
  }

  /// Fetch data asynchronously and return the raw response.
  internal func fetch(req: HTTPRequestBuilder) async throws -> (Data, HTTPURLResponse) {
    if req.headers.index(forKey: "Content-Type") == nil {
      req.headers["Content-Type"] = "application/json"
    }

    if req.headers.index(forKey: "Accept") == nil {
      req.headers["Accept"] = "application/json"
    }

    if req.headers.index(forKey: "User-Agent") == nil {
      req.headers["User-Agent"] = "FeedbackSDKSwift"
    }

    let request = try req.build()
    return try await dataTask(request)
  }

  internal func dataTask(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
    if debugRequests {
      zofxLogger.debug("➡️ 🌏 \(request.httpMethod ?? "-") \(request.url?.absoluteString ?? "-")")
      for (k, v) in request.allHTTPHeaderFields ?? [:] {
        zofxLogger.debug("➡️ 🏷️ '\(k)': '\(v)'")
      }
      if let httpBody = request.httpBody {
        zofxLogger.debug(
          "➡️ 💿 \(String(describing: httpBody.prettyPrintedJSONString ?? String(data: httpBody, encoding: .utf8) ?? "Undecodable"))"
        )
      }
    }
    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw FeedbackSDKError.nonHTTPURLResponse(data: data, response: response)
    }

    if debugResponses {
      zofxLogger.debug("⬅️ 🌍 \(httpResponse.url?.absoluteString ?? "-")")
      zofxLogger.debug("⬅️ 🚦 HTTP \(httpResponse.statusCode)")
      for (k, v) in httpResponse.allHeaderFields {
        zofxLogger.debug("⬅️ 🏷️ '\(k)': '\(String(describing: v))'")
      }
      zofxLogger.debug(
        "⬅️ 💿 \(String(describing: data.prettyPrintedJSONString ?? String(data: data, encoding: .utf8) ?? "Undecodable"))"
      )
    }

    guard validStatusCodes.contains(httpResponse.statusCode) else {
      throw FeedbackSDKError.invalidStatusCode(data: data, response: httpResponse)
    }

    return (data, httpResponse)
  }
}

extension FeedbackSDKClient {

  public func reportValue(
    content: String, file: Data? = nil, mimeType: String? = nil, email: String? = nil,
    attrs: [String: String]? = nil
  ) async throws {
    let req = try HTTPRequestBuilder {
      $0.url = getURL(["api", "values"])
      $0.method = .post
      var parts = [MultipartPart]()
      parts.append(
        MultipartPart(
          headers: [
            "Content-Disposition": "form-data; name=\"value[key]\""
          ],
          body: appKey
        )
      )
      parts.append(
        MultipartPart(
          headers: [
            "Content-Disposition": "form-data; name=\"value[content]\""
          ],
          body: content
        )
      )
      if let file, let mimeType {
        parts.append(
          MultipartPart(
            headers: [
              "Content-Disposition": "form-data; name=\"file\"; filename=\"screenshot.jpeg\"",
              "Content-Type": mimeType,
            ],
            body: file
          )
        )
      }

      if let trimmedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines),
        !trimmedEmail.isEmpty
      {
        parts.append(
          MultipartPart(
            headers: [
              "Content-Disposition": "form-data; name=\"value[email]\""
            ],
            body: trimmedEmail
          )
        )
      }

      if let attrs = attrs {
        for (k, v) in attrs {
          parts.append(
            MultipartPart(
              headers: [
                "Content-Disposition": "form-data; name=\"value[attributes][\(k)]\""
              ],
              body: v
            )
          )
        }
      }

      $0.body = try .multipart(parts, boundary: UUID().uuidString)
    }
    let _ = try await fetch(req: req)
  }
}
