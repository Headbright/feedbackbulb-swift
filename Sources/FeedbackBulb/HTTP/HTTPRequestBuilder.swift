// Created by konstantin on 23/11/2022.
// Copyright (c) 2022. All rights reserved.

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

internal final class HTTPRequestBuilder: HTTPRequest {

  /// Initialize a new request.
  ///
  /// - Parameters:
  ///   - configure: configure callback.
  init(with configure: ((inout HTTPRequestBuilder) throws -> Void)) rethrows {
    var this = self
    try configure(&this)
  }

  /// URLComponents of the network request.
  var urlComponents = URLComponents()

  /// Set the full absolute URL for the request
  var url: URL? {
    get {
      urlComponents.url
    }
    set {
      if let url = newValue,
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
      {
        urlComponents = components
      }
    }
  }

  var method: HTTPMethod = .get

  var headers: [String: String] = [:]

  /// Add a new query parameter to the query string's value.
  ///
  /// - Parameters:
  ///   - name: name of the parameter to add.
  ///   - value: value of the parameter to add.
  func addQueryParameter(name: String, value: String) {
    let item = URLQueryItem(name: name, value: value)
    add(queryItem: item)
  }

  /// Add a new query parameter via `URLQueryItem` instance.
  ///
  /// - Parameter item: instance of the query item to add.
  func add(queryItem item: URLQueryItem) {
    if query != nil {
      query?.append(item)
    } else {
      query = [item]
    }
  }

  /// Setup a list of query string parameters.
  var query: [URLQueryItem]? {
    get { urlComponents.queryItems }
    set { urlComponents.queryItems = newValue }
  }

  var body: HTTPBody?
}

extension HTTPRequestBuilder {
  /// Create an instance of `URLRequest` using the current configuration
  func build() throws -> URLRequest {
    guard let url else {
      throw FeedbackSDKError.requiredURLNotSet
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    urlRequest.allHTTPHeaderFields = headers

    if let body {
      urlRequest.httpBody = body.content
      for header in body.headers ?? [:] {
        urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
      }
    }

    return urlRequest
  }
}
