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

  private func encodedRequestForgeryState() -> String {
    return (NSUUID().UUIDString).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(nil)
  }

}
