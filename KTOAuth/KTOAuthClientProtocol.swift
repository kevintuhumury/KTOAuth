//
//  KTOAuthClientProtocol.swift
//  KTOAuth
//
//  Created by Kevin Tuhumury on 08/02/15.
//  Copyright (c) 2015 Kevin Tuhumury. All rights reserved.
//

import Foundation

protocol KTOAuthClientProtocol {

  func didReceiveAccessToken(json: AnyObject?) -> Void

}
