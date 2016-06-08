//
//  OAuthCredentialsCache.swift
//  SimplicityTest
//
//  Created by Marcilio Junior on 6/7/16.
//  Copyright © 2016 HE:labs. All rights reserved.
//

import OAuthSwift
import RxSwift

class OAuthCredentialsCache {
    
    private var memoryCache: [String: AnyObject]
    private let fileCache = FileCache()
    
    static let sharedInstance = OAuthCredentialsCache()
    
    private init() {
        memoryCache = [String: AnyObject]()
    }
    
    func add(key: String, object: OAuthSwiftCredential) {
        memoryCache.updateValue(object, forKey: key)
        fileCache.save(key, data: object)
    }
    
    func get(key: String) -> Observable<OAuthSwiftCredential>? {
        var credential = memoryCache[key]
        if credential == nil {
            credential = fileCache.get(key)
            if let credential = credential {
                memoryCache.updateValue(credential, forKey: key)
            }
        }
        
        return credential as? Observable<OAuthSwiftCredential>
    }
    
    func evict(key: String) {
        memoryCache.removeValueForKey(key)
        fileCache.evict(key)
    }
    
}

private class FileCache {
    
    private let cacheDirectory: String
    private let directory = "RxGoogleSignInCredentials"
    
    init() {
        let fileManager = NSFileManager.defaultManager()
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dirPath = documentsDirectory.stringByAppendingPathComponent(directory)
        
        if !fileManager.fileExistsAtPath(dirPath) {
            do {
                try fileManager.createDirectoryAtPath(dirPath, withIntermediateDirectories: false, attributes: nil)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        cacheDirectory = dirPath + "/"
    }
    
    func save(key: String, data: OAuthSwiftCredential) -> Bool {
        return NSKeyedArchiver.archiveRootObject(data, toFile: cacheDirectory + key)
    }
    
    func get(keyToken: String) -> Observable<OAuthSwiftCredential>? {
        if let response = retrieve(keyToken) {
            if !response.isTokenExpired() {
                return Observable.just(response)
            }
        }
        
        return nil
    }
    
    private func retrieve(key: String) -> OAuthSwiftCredential? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(cacheDirectory+key) as? OAuthSwiftCredential
    }
    
    func evict(key: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(cacheDirectory+key)
        }
        catch { }
    }
    
}