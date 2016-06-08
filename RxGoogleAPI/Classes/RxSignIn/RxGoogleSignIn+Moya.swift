//
//  RxGoogleSignIn+Moya.swift
//  SimplicityTest
//
//  Created by Marcilio Junior on 6/7/16.
//  Copyright © 2016 HE:labs. All rights reserved.
//

import Moya
import RxSwift
import RxBlocking

extension RxGoogleSignIn {
    
    static func addOAuthHeader(provider: GoogleSignInProvider.Type, endpoint: Endpoint<GoogleAPI>) -> Endpoint<GoogleAPI> {
        do {
            let credential = try RxGoogleSignIn.getOAuthCredential().toBlocking().first()
            let headers = ["Authorization" : "Bearer \(credential!.oauth_token)"]
            return endpoint.endpointByAddingHTTPHeaderFields(headers)
        }
        catch {
            return endpoint
        }
    }
    
}
