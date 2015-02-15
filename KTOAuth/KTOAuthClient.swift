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
  var isRetrievingAuthenticationCode = false

  init(clientId: String, clientSecret: String, redirectURI: String, authorizeURL: String, tokenURL: String) {
    self.clientId     = clientId
    self.clientSecret = clientSecret
    self.redirectURI  = redirectURI
    self.authorizeURL = authorizeURL
    self.tokenURL     = tokenURL

    requestForgeryState = encodedRequestForgeryState()
  }

  func retrieveAuthorizationCode(url: NSString) -> Bool {
    isRetrievingAuthenticationCode = url.hasPrefix(redirectURI)

    if isRetrievingAuthenticationCode == true {
      if url.rangeOfString("error").location != NSNotFound {
        let error = NSError(domain: "nl.kevintuhumury.ktoauthclient", code: 0, userInfo: nil)
        delegate?.didReceiveAuthorizationCodeError(error)
      } else {
        if let state = getQueryStringParameter(url, param: "state") {
          if state == requestForgeryState {
            if let authorizationCode = getQueryStringParameter(url, param: "code") {
              retrieveAccessTokenWith(authorizationCode)
            }
          }
        }
      }
    }
    return true
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

  class func accessTokenHasExpired(expireDate: NSDate) -> Bool {
    return expireDate != expireDate.laterDate(NSDate())
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

  private func refreshTokenUrlFor(refreshToken: String) -> String {
    return tokenURL
      + "?grant_type=refresh_token"
      + "&client_id=" + clientId
      + "&client_secret=" + clientSecret
      + "&redirect_uri=" + redirectURI.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
      + "&refresh_token=" + refreshToken
  }

  private func encodedRequestForgeryState() -> String {
    return (NSUUID().UUIDString).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(nil)
  }

  private func getQueryStringParameter(url: String, param: String) -> String? {
    let url = NSURLComponents(string: url)!
    return (url.queryItems? as [NSURLQueryItem]).filter { (item) in item.name == param }.first?.value
  }

}
