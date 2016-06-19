//
//  RxGoogleSignIn.swift
//  SimplicityTest
//
//  Created by Marcilio Junior on 6/4/16.
//  Copyright © 2016 HE:labs. All rights reserved.
//

import Foundation
import OAuthSwift
import RxSwift

public class RxGoogleSignIn {
    
    private static let cacheKey = String(OAuthSwiftCredential).componentsSeparatedByString(".").last!
    
    public static var isUserLogged: Bool {
        return OAuthCredentialsCache.sharedInstance.get(RxGoogleSignIn.cacheKey) != nil
    }
    
    public class func login(provider: GoogleSignInProvider) -> Observable<OAuthSwiftCredential> {
        if let credentialObservable = OAuthCredentialsCache.sharedInstance.get(cacheKey) {
            return credentialObservable
        }
        
        return Observable.create { observer in
            let oauthProvider = OAuth2Swift(consumerKey: provider.clientId, consumerSecret: "", authorizeUrl: provider.authorizeURL, accessTokenUrl: provider.accessTokenURL, responseType: provider.responseType)
            
            if let viewController = UIApplication.sharedApplication().delegate?.window??.rootViewController {
                let urlHandler = SafariURLHandler(viewController: viewController)
                urlHandler.rx_safariViewControllerDidFinish.subscribeNext {
                    observer.on(.Completed)
                }
                oauthProvider.authorize_url_handler = urlHandler                
            }                                                 
            
            oauthProvider.authorizeWithCallbackURL(provider.callbackURL, scope: provider.scope, state: provider.state, success: { (credential, response, parameters) in
                OAuthCredentialsCache.sharedInstance.add(cacheKey, object: credential)
                
                observer.on(.Next(credential))
                observer.on(.Completed)
            }, failure: { error in
                observer.on(.Error(error))
            })
            
            return NopDisposable.instance
        }
    }
    
    public class func closeCurrentConnection() -> Observable<Void> {
        return Observable.deferred {
            OAuthCredentialsCache.sharedInstance.evict(cacheKey)
            return Observable.just()
        }
    }
    
    public class func getOAuthCredential() -> Observable<OAuthSwiftCredential> {
        return Observable.deferred {
            if let credential = OAuthCredentialsCache.sharedInstance.get(cacheKey) {
                return credential
            }
                
            return Observable.error(GoogleSignInError.ActiveTokenNotFound)
        }
    }
    
}
