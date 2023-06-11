// Created by konstantin on 23/11/2022.
// Copyright (c) 2022. All rights reserved.

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

internal protocol HTTPRequest {
  /// The destination url of the rqeuest
  var url: URL? { get set }

  /// Method for submitting the request
  var method: HTTPMethod { get set }

  /// Add a new query parameter to the query string's value.
  ///
  /// - Parameters:
  ///   - name: name of the parameter to add.
  ///   - value: value of the parameter to add.
  func addQueryParameter(name: String, value: String)

  /// Contains the headers and optionally a payload body for the request
  var body: HTTPBody { get set }

  /// Create an instance of `URLRequest` using the current configuration
  func build() throws -> URLRequest
}
