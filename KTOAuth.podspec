Pod::Spec.new do |s|

  s.name         = "KTOAuth"
  s.version      = "0.0.1"
  s.summary      = "OAuth2 library for iOS written in Swift."

  s.description  = <<-DESC
                   KTOAuth is a Swift library which let's the user authenticate against a
                   webservice using OAuth2. It was designed to use it to authenticate through
                   a UIWebView inside a UIViewController, but you can use it in combination
                   with openURL: and Safari as well.
                   DESC

  s.homepage     = "https://github.com/kevintuhumury/KTOAuth"
  s.license      = { type: "MIT", file: "LICENSE" }
  s.author       = { "Kevin Tuhumury" => "kevin.tuhumury@gmail.com" }

  s.platform     = :ios, "8.0"
  s.source       = { git: "https://github.com/kevintuhumury/KTOAuth.git", tag: s.version }
  s.source_files = "KTOAuth/*.swift"

  s.dependency "Alamofire", "~> 1.1"
  s.dependency "SwiftyJSON", "2.1.3"

end
