//
//  KTOAuthClient.swift
//  KTOAuth
//
//  Created by Kevin Tuhumury on 08/02/15.
//  Copyright (c) 2015 Kevin Tuhumury. All rights reserved.
//

import Foundation

class KTOAuthClient {

  var delegate: KTOAuthClientDelegate?

  var clientId: String
  var clientSecret: String
  var redirectURI: String
  var authorizeURL: String
  var tokenURL: String

  var requestForgeryState: String?

  init(clientId: String, clientSecret: String, redirectURI: String, authorizeURL: String, tokenURL: String) {
    self.clientId     = clientId
    self.clientSecret = clientSecret
    self.redirectURI  = redirectURI
    self.authorizeURL = authorizeURL
    self.tokenURL     = tokenURL

    requestForgeryState = encodedRequestForgeryState()
  }

  private func encodedRequestForgeryState() -> String {
    return (NSUUID().UUIDString).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(nil)
  }

}
