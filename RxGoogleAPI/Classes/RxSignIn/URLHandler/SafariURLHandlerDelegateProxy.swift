//
//  SafariURLHandlerDelegateProxy.swift
//  Pods
//
//  Created by Marcilio Junior on 6/19/16.
//
//

import Foundation
import RxSwift
import RxCocoa
import OAuthSwift
import SafariServices

class RxSafariURLHandlerDelegateProxy: DelegateProxy, DelegateProxyType, SFSafariViewControllerDelegate {
    
    static func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let urlHandler = object as! SafariURLHandler
        return urlHandler.delegate
    }
    
    static func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let urlHandler = object as! SafariURLHandler
        urlHandler.delegate = delegate as? SFSafariViewControllerDelegate
    }
    
}

extension SafariURLHandler {
    
    public var rx_delegate: DelegateProxy {
        return RxSafariURLHandlerDelegateProxy.proxyForObject(self)
    }
    
    public var rx_safariViewControllerDidFinish: Observable<Void> {
        return rx_delegate.observe("safariViewControllerDidFinish:")
            .map { _ in Observable.just() }
    }
    
}
