// Created by konstantin on 02/11/2022
// Copyright (c) 2022. All rights reserved.

import Foundation

internal final class FeedbackSDKDecoder: JSONDecoder {
  internal override init() {
    super.init()
    keyDecodingStrategy = .convertFromSnakeCase
  }
}
