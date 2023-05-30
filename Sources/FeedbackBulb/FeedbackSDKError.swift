// Created by konstantin on 02/11/2022
// Copyright (c) 2022. All rights reserved.

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public enum FeedbackSDKError: Error, LocalizedError, Equatable {
  case decodingError(_ description: String)
  case requiredURLNotSet
  case nonHTTPURLResponse(data: Data, response: URLResponse)
  case invalidStatusCode(data: Data, response: HTTPURLResponse)
  case unexpectedError(_ description: String)
  case internalError(_ description: String)

  public var errorDescription: String? {
    switch self {
    case .decodingError(let description):
      return "[FeedbackSDK bug] There was an error decoding incoming data:\n" + description + "."
    case .nonHTTPURLResponse:
      return "Unexpected response."
    case .requiredURLNotSet:
      return "[FeedbackSDK bug] HTTPRequestBuilder was used without setting a url."
    case .invalidStatusCode(_, let response):
      return "Invalid HTTP status code: \(response.statusCode)."
    case .unexpectedError(let description):
      return "Unexpected error: \(description)"
    case .internalError(let description):
      return "[FeedbackSDK bug] " + description + "."
    }
  }
}
