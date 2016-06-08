//
//  GoogleProvider.swift
//  SimplicityTest
//
//  Created by Marcilio Junior on 6/4/16.
//  Copyright © 2016 HE:labs. All rights reserved.
//

import OAuthSwift

class GoogleSignInProvider: OAuth2Swift {
    
    var scope: String
    var clientId: String
    var callbackURL: NSURL
    
    let state           = String(arc4random_uniform(10000000))
    let authorizeURL    = "https://accounts.google.com/o/oauth2/auth"
    let accessTokenURL  = "https://www.googleapis.com/oauth2/v4/token"
    let responseType    = "code"
    
    init(scopes: [String] = ["email", "profile"]) {
        guard let urlScheme = InfoPlistHelper.registeredURLSchemes(filter: {$0.hasPrefix("com.googleusercontent.apps.")}).first else {
            preconditionFailure("You must configure your Google URL Scheme to use Google login.")
        }
        
        self.scope       = scopes.joinWithSeparator(" ")
        self.clientId    = urlScheme.componentsSeparatedByString(".").reverse().joinWithSeparator(".")
        self.callbackURL = NSURL(string: "\(urlScheme):/oauth2callback")!
        
        super.init(consumerKey: self.clientId, consumerSecret: "", authorizeUrl: self.authorizeURL, responseType: self.responseType)
    }
    
}
