/*
Multipart support is provided by the https://github.com/davbeck/MultipartForm package which has been incorported as part of the source code of this library.

Copyright (c) 2018 David Beck <code@davidbeck.co>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

import Foundation

struct MultipartForm: Hashable, Equatable {
  struct Part: Hashable, Equatable {
    var name: String
    var data: Data
    var filename: String?
    var contentType: String?

    var value: String? {
      get {
        return String(bytes: self.data, encoding: .utf8)
      }
      set {
        guard let value = newValue else {
          self.data = Data()
          return
        }

        self.data = value.data(using: .utf8, allowLossyConversion: true)!
      }
    }

    init(name: String, data: Data, filename: String? = nil, contentType: String? = nil) {
      self.name = name
      self.data = data
      self.filename = filename
      self.contentType = contentType
    }

    init(name: String, value: String) {
      let data = value.data(using: .utf8, allowLossyConversion: true)!
      self.init(name: name, data: data, filename: nil, contentType: nil)
    }
  }

  enum MultipartType: String {
    case formData = "form-data"
    case mixed = "mixed"
  }

  var boundary: String
  var parts: [Part]
  var multipartType: MultipartType

  var contentType: String {
    return "multipart/\(multipartType.rawValue); boundary=\(self.boundary)"
  }

  var bodyData: Data {
    var body = Data()
    for part in self.parts {
      body.append("--\(self.boundary)\r\n")
      body.append("Content-Disposition: form-data; name=\"\(part.name)\"")
      if let filename = part.filename?.replacingOccurrences(of: "\"", with: "_") {
        body.append("; filename=\"\(filename)\"")
      }
      body.append("\r\n")
      if let contentType = part.contentType {
        body.append("Content-Type: \(contentType)\r\n")
      }
      body.append("\r\n")
      body.append(part.data)
      body.append("\r\n")
    }
    body.append("--\(self.boundary)--\r\n")

    return body
  }

  init(
    parts: [Part] = [], boundary: String = UUID().uuidString,
    multipartType: MultipartType = .formData
  ) {
    self.parts = parts
    self.boundary = boundary
    self.multipartType = multipartType
  }

  subscript(name: String) -> Part? {
    get {
      return self.parts.first(where: { $0.name == name })
    }
    set {
      precondition(newValue == nil || newValue?.name == name)

      var parts = self.parts
      parts = parts.filter { $0.name != name }
      if let newValue = newValue {
        parts.append(newValue)
      }
      self.parts = parts
    }
  }
}
