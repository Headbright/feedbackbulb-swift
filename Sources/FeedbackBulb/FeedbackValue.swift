//
//  File.swift
//
//
//  Created by Konstantin on 04/03/2023.
//

import Foundation

public protocol FeedbackModelProtocols: Codable, Hashable, Sendable {}

// public struct FeedbackResponse<T>: FeedbackModelProtocols where T: FeedbackModelProtocols {
//   public var data: T
// }

public struct FeedbackValueResponse: FeedbackModelProtocols {
  /// A one-time token which can be used to retrieve a reply to this feedback report.
  /// The client can choose to store this token in a safe place (treat it like a secret) and use it to check for replies.
  /// Once  a reply is retrieved, the token will expire and can be safely deleted by the client.
  public var replyToken: String?
}
