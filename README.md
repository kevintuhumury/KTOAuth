# KTOAuth

KTOAuth is a Swift library which let's the user authenticate against a webservice using OAuth2. I'm using to authenticate through a `UIWebView` inside a `UIViewController`, but you could probably still use it in Safari as well (hint: use `openURL:` and handle the redirect in your app).

## Installation

### Cocoapods

Soon, really soon.

### In the meantime

Add the `KTOAuth` folder manually to your project.

## Usage

In order for you to receive an `access_token`, you'll have to instantiate a new instance of `KTOAuthClient` and set the `UIViewController` as the delegate of the client:

```swift
var client = KTOAuthClient(clientId: Config.OAuth.ClientID, clientSecret: Config.OAuth.ClientSecret, redirectURI: Config.OAuth.RedirectURI, authorizeURL: Config.OAuth.AuthorizeURL, tokenURL: Config.OAuth.TokenURL)
client.delegate = self
```

I've used the example `Config` struct included in this repository to set the required data and passed that into the `KTOAuthClient` init as can be seen above.

The next step is to generate the authorize URL which you'll have to load in the `UIWebView`:

```swift
webView.loadRequest(NSURLRequest(URL: NSURL(string: client.authorizeUrl())!))
```

Next up is the call to the `retrieveAuthorizationCode` method to start the OAuth2 process. You'll probably want to call it in the `webView:shouldStartLoadWithRequest:navigationType` delegate method of `UIWebViewDelegate`:

```swift
extension WebViewController: UIWebViewDelegate {
  func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
    return client.retrieveAuthorizationCode(request.URL.absoluteString!)
  }
}
```

Now all you need to do is add the required `KTOAuthClientDelegate` protocol methods and you're done:

```swift
extension WebViewController: KTOAuthClientDelegate {
  func didReceiveAccessToken(json: JSON) {
  	println(json)
  }

  func didReceiveAccessTokenError(error: NSError) -> Void {
    println(error)
  }

  func didReceiveAuthorizationCodeError(error: NSError) -> Void {
    println(error)
  }
}
```

## Dependencies

* [Alamofire](https://github.com/Alamofire/Alamofire) - Elegant HTTP Networking in Swift.
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) - The better way to deal with JSON data in Swift.

## Copyright

Copyright 2015 Kevin Tuhumury. Released under the MIT License.
