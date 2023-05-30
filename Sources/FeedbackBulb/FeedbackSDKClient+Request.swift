//
//  File.swift
//
//
//  Created by Konstantin on 04/03/2023.
//

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension FeedbackSDKClient {

  internal func getURL(_ components: [String]) -> URL {
    var url = instanceURL
    for component in components {
      url.appendPathComponent(component)
    }
    return url
  }
}
