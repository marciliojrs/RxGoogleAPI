//
//  GoogleAPI.swift
//  SimplicityTest
//
//  Created by Marcilio Junior on 6/5/16.
//  Copyright © 2016 HE:labs. All rights reserved.
//

import RxSwift
import OAuthSwift
import Moya

enum GoogleAPI {
    case Me
}

extension GoogleAPI: TargetType {
    
    var baseURL: NSURL {
        return NSURL(string: "https://www.googleapis.com/plus/v1")!
    }
    
    var path: String {
        switch(self) {
        case .Me:
            return "/people/me"
        }
    }
    
    var URL: String {
        return "\(baseURL)\(path)"
    }
    
    var method: Moya.Method {
        switch(self) {
        case .Me:
            return .GET
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch(self) {
        case .Me:
            return .URL
        }
    }
    
    var parameters: [String: AnyObject]? {
        return nil
    }
    
    var sampleData: NSData {
        switch self {
        default:
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }

    
}

