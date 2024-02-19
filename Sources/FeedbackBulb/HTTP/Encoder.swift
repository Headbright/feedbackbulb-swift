// Created by konstantin on 02/11/2022
// Copyright (c) 2022. All rights reserved.

import Foundation

internal final class FeedbackSDKEncoder: JSONEncoder {
  /// Creates a new instance of `FeedbackSDKEncoder`
  public override init() {
    super.init()
    keyEncodingStrategy = .convertToSnakeCase
  }
}
