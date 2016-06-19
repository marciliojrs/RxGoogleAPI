//
//  GoogleAPIClient.swift
//  SimplicityTest
//
//  Created by Marcilio Junior on 6/5/16.
//  Copyright © 2016 HE:labs. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public class GoogleAPIClient {
    
    private let disposeBag = DisposeBag()
    
    public init() { }
    
    private let provider = RxMoyaProvider<GoogleAPI>(endpointClosure: { (target: GoogleAPI) -> Endpoint<GoogleAPI> in
        let endpoint: Endpoint<GoogleAPI> = Endpoint<GoogleAPI>(URL: target.URL, sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
        
        return RxGoogleSignIn.addOAuthHeader(GoogleSignInProvider.self, endpoint: endpoint)                
    })
        
    public func getMe() -> Observable<[String: AnyObject]> {
        return Observable.create { observer in
            self.provider.request(GoogleAPI.Me).subscribe { (event) in
                switch event {
                case let .Next(response):
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as! [String: AnyObject]
                        observer.onNext(json)
                    }
                    catch let error {
                        observer.onError(error)
                    }
                case let .Error(error):
                    observer.onError(error)
                case .Completed:
                    observer.onCompleted()
                }
            }
        }
    }
    
}
