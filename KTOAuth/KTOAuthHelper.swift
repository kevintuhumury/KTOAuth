//
//  KTOAuthHelper.swift
//  KTOAuth
//
//  Created by Kevin Tuhumury on 07/02/15.
//  Copyright (c) 2015 Kevin Tuhumury. All rights reserved.
//

import Foundation

class KTOAuthHelper {

  class func sharedInstance() -> KTOAuthHelper {
    struct Singleton {
      static let helper = KTOAuthHelper()
    }
    return Singleton.helper
  }

  func authorizeURL() -> String {
    return baseURL() + "/oauth/authorize"
  }

  func tokenURL() -> String {
    return baseURL() + "/oauth/token"
  }

  func redirectURI() -> String {
    return "app://oauth/callback"
  }

  func clientID() -> String {
    return "CLIENT_ID"
  }

  func clientSecret() -> String {
    return "CLIENT_SECRET"
  }

  private

  func baseURL() -> String {
    return "https://example.com"
  }

}
