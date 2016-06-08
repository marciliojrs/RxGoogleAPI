//
//  InfoPlistHelper.swift
//  SimplicityTest
//
//  Created by Marcilio Junior on 6/5/16.
//  Copyright © 2016 HE:labs. All rights reserved.
//

import Foundation

struct InfoPlistHelper {

    static func registeredURLSchemes(filter closure: String -> Bool) -> [String] {
        guard let urlTypes = NSBundle.mainBundle().infoDictionary?["CFBundleURLTypes"] as? [[String: AnyObject]] else {
            return [String]()
        }
        
        let urlSchemes = urlTypes.flatMap({($0["CFBundleURLSchemes"] as? [String])?.first })
        
        return urlSchemes.flatMap({closure($0) ? $0 : nil})
    }
    
}
