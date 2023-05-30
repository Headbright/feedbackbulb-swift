// Created by konstantin on 02/12/2022.
// Copyright (c) 2022. All rights reserved.

import Foundation

extension Data {
  /// NSString gives us a nice sanitized debugDescription
  var prettyPrintedJSONString: String? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
      let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
      let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    else { return nil }

    return prettyPrintedString as String
  }
}
