//
//  KTOAuthClient.swift
//  KTOAuth
//
//  Created by Kevin Tuhumury on 08/02/15.
//  Copyright (c) 2015 Kevin Tuhumury. All rights reserved.
//

import Alamofire
import SwiftyJSON

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

  func retrieveAccessTokenWith(authorizationCode: String) -> Void {
    Alamofire.request(.POST, tokenUrlFor(authorizationCode), parameters: nil, encoding: Alamofire.ParameterEncoding.URL).responseJSON { (_, _, data, error) -> Void in
      if let error = error {
        self.delegate?.didReceiveAccessTokenError(error)
      } else {
        self.delegate?.didReceiveAccessToken(JSON(data!))
      }
    }
  }

  func authorizeUrl() -> String {
    return authorizeURL
      + "?response_type=code"
      + "&state=" + requestForgeryState!
      + "&client_id=" + clientId
      + "&redirect_uri=" + redirectURI.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
  }

  private func tokenUrlFor(authorizationCode: String) -> String {
    return tokenURL
      + "?grant_type=authorization_code"
      + "&client_id=" + clientId
      + "&client_secret=" + clientSecret
      + "&redirect_uri=" + redirectURI.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
      + "&code=" + authorizationCode
  }

  private func encodedRequestForgeryState() -> String {
    return (NSUUID().UUIDString).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(nil)
  }

  private func getQueryStringParameter(url: String, param: String) -> String? {
    let url = NSURLComponents(string: url)!
    return (url.queryItems? as [NSURLQueryItem]).filter { (item) in item.name == param }.first?.value
  }

}
