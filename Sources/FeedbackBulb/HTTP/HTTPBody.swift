// Created by konstantin on 23/11/2022.
// Copyright (c) 2022. All rights reserved.

import Foundation

internal struct HTTPBody {
  // The payload of the request body
  internal var content: Data?
  // Header values associated with the request
  internal var headers: [String: String]
}

extension HTTPBody {
  /// Initialize a new body with an object conform to `Encodable` which will converted to a JSON string.
  ///
  /// - Returns: HTTPBody
  static func json<T: Encodable>(_ object: T, encoder: JSONEncoder = .init()) throws -> HTTPBody {
    let data = try encoder.encode(object)
    let headers = ["Content-Type": "application/json"]
    return HTTPBody(content: data, headers: headers)
  }

  static func subPart(variable: String, value: String) -> MultipartForm.Part {
    .init(name: variable, value: value)
  }

  static func subPart(field: String, fileName: String, mimeType: String, data: Data) throws
    -> MultipartForm.Part
  {
    .init(name: field, data: data, filename: fileName, contentType: mimeType)
  }

  static func multipart(@MultipartFormBuilder _ builder: () throws -> [MultipartForm.Part]) rethrows
    -> HTTPBody
  {
    let parts = try builder()
    let form = MultipartForm(parts: parts)

    let headers = ["Content-Type": form.contentType]
    return HTTPBody(content: form.bodyData, headers: headers)
  }

  /// Initialize a new body for a application/x-www-form-urlencoded request with values from the provided URLComponents
  ///
  /// - Returns: HTTPBody
  static func form(components: URLComponents) throws -> HTTPBody {
    let data = components.query?.data(using: .utf8)
    let headers = ["Content-Type": "application/x-www-form-urlencoded"]
    return HTTPBody(content: data, headers: headers)
  }

  /// Initialize a new body for a application/x-www-form-urlencoded request with values from the provided query items
  ///
  /// - Returns: HTTPBody
  static func form(queryItems: [URLQueryItem]) throws -> HTTPBody {
    var components = URLComponents()
    components.queryItems = queryItems
    return try form(components: components)
  }
}

@resultBuilder
enum MultipartFormBuilder {
  // swiftlint:disable missing_docs

  static func buildExpression(_ expression: MultipartForm.Part) -> [MultipartForm.Part] {
    return [expression]
  }

  static func buildBlock(_ components: [MultipartForm.Part]...) -> [MultipartForm.Part] {
    return components.flatMap { $0 }
  }

  static func buildArray(_ components: [[MultipartForm.Part]]) -> [MultipartForm.Part] {
    return components.flatMap { $0 }
  }

  // swiftlint:disable:next discouraged_optional_collection
  static func buildOptional(_ component: [MultipartForm.Part]?) -> [MultipartForm.Part] {
    return component ?? []
  }

  static func buildEither(first component: [MultipartForm.Part]) -> [MultipartForm.Part] {
    return component
  }

  static func buildEither(second component: [MultipartForm.Part]) -> [MultipartForm.Part] {
    return component
  }
  // swiftlint:enable missing_docs
}
