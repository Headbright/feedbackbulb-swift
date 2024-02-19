import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// Http client to communicate with FeedbackBulb's REST API
public struct FeedbackSDKClient {
  /// The URL of the instance we're connected to
  public var instanceURL: URL
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
    appKey: String
  ) {
    self.session = URLSession.shared
    self.instanceURL = URL(string: "https://feedbackbulb.com")!
    self.appKey = appKey
  }

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
    self.debugResponses = true
    self.debugInstance = true
  }

  /// Stops printing debug details
  public mutating func debugOff() {
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
        loggerResponse.debug("\(description, privacy: .public)")
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
        loggerResponse.debug("\(description, privacy: .public)")
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

    if req.body.headers.index(forKey: "Content-Type") == nil {
      req.body.headers["Content-Type"] = "application/json"
    }

    if req.body.headers.index(forKey: "Accept") == nil {
      req.body.headers["Accept"] = "application/json"
    }

    if req.body.headers.index(forKey: "User-Agent") == nil {
      req.body.headers["User-Agent"] = "Swift feedbackbulb.com"
    }

    let request = try req.build()
    return try await dataTask(request)
  }

  internal func dataTask(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw FeedbackSDKError.nonHTTPURLResponse(data: data, response: response)
    }

    if debugResponses {
      loggerResponse.debug(
        "⬅️ 🌍 \(httpResponse.url?.absoluteString ?? "-", privacy: .public) HTTP \(httpResponse.statusCode)"
      )
      for (k, v) in httpResponse.allHeaderFields {
        loggerResponse.debug(
          "⬅️ 🏷️ '\(k, privacy: .public)': '\(String(describing: v), privacy: .public)'")
      }
      loggerResponse.debug("⬅️ Body: \(data.prettyPrintedJSONStringOrString, privacy: .public)")
    }

    guard validStatusCodes.contains(httpResponse.statusCode) else {
      throw FeedbackSDKError.invalidStatusCode(data: data, response: httpResponse)
    }

    return (data, httpResponse)
  }
}

extension FeedbackSDKClient {

  public func submitFeedback(content: String, attrs: [String: String]? = nil) async throws {
    let req = HTTPRequestBuilder {
      $0.url = getURL(["api", "values"])
      $0.method = .post
      $0.body = .multipart {
        HTTPBody.subPart(variable: "value[key]", value: appKey)
        HTTPBody.subPart(variable: "value[content]", value: content)

        if let attrs = attrs {
          for (k, v) in attrs {
            HTTPBody.subPart(variable: "value[attributes][\(k)]", value: v)
          }
        }
      }
    }

    let _ = try await fetch(req: req)
  }

  public func submitFeedback(
    content: String, fileName: String, file: Data? = nil, mimeType: String? = nil,
    email: String? = nil,
    attrs: [String: String]? = nil
  ) async throws {

    let req = try HTTPRequestBuilder {
      $0.url = getURL(["api", "values"])
      $0.method = .post
      $0.body = try .multipart {
        HTTPBody.subPart(variable: "value[key]", value: appKey)
        HTTPBody.subPart(variable: "value[content]", value: content)

        if let file, let mimeType {
          try HTTPBody.subPart(field: "file", fileName: fileName, mimeType: mimeType, data: file)
        }

        if let trimmedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines),
          !trimmedEmail.isEmpty
        {
          HTTPBody.subPart(variable: "value[email]", value: trimmedEmail)
        }

        if let attrs = attrs {
          for (k, v) in attrs {
            HTTPBody.subPart(variable: "value[attributes][\(k)]", value: v)
          }
        }
      }
    }
    let _ = try await fetch(req: req)
  }
}
