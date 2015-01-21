//
//  BriskClient.swift
//  Brisk
//
//  Created by Michael Armstrong on 05/06/2014.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation
import UIKit

class BriskClient: NSObject, NSURLSessionDelegate {
    
    var queue : NSOperationQueue {
        get {
            return NSOperationQueue.currentQueue()!
        }
    }
    
    var sessionConfiguration : NSURLSessionConfiguration {
        get {
            return NSURLSessionConfiguration.defaultSessionConfiguration()
        }
    }
    
    typealias dataForURLCompletionClosure = ((NSURLResponse!, NSData!, NSError!) -> Void)!
    typealias stringForURLCompletionClosure = ((NSURLResponse!, NSString!, NSError!) -> Void)!
    
    func dataForURL(url : NSURL, completionHandler handler: dataForURLCompletionClosure) {
        var request = NSURLRequest(URL:url)
        let urlSession = NSURLSession(configuration:sessionConfiguration, delegate: self, delegateQueue: queue)
        
        let sessionTask = urlSession.dataTaskWithRequest(request, completionHandler: {(data: NSData!, response : NSURLResponse!, error: NSError!) -> Void in
            handler(response,data,error)
        })
        sessionTask.resume()
    }
    
    func dataForRequest(request : NSURLRequest!, completionHandler handler: dataForURLCompletionClosure) {
        let urlSession = NSURLSession(configuration:sessionConfiguration, delegate: self, delegateQueue: queue)
        
        let finalRequest = request.copy() as NSURLRequest
        let sessionTask = urlSession.dataTaskWithRequest(finalRequest, completionHandler: {(data: NSData!, response : NSURLResponse!, error: NSError!) -> Void in
            handler(response,data,error)
        })
        sessionTask.resume()
    }
    
    func dataForURL(url : NSURL, postData: NSData, completionHandler handler: dataForURLCompletionClosure) {
        let request = NSMutableURLRequest(URL:url)
        let urlSession = NSURLSession(configuration:sessionConfiguration, delegate: self, delegateQueue: queue)
        request.HTTPMethod = "POST"
        
        if(postData.length != 0){
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = postData
        }
        
        
        let finalRequest = request.copy() as NSURLRequest
        let sessionTask = urlSession.dataTaskWithRequest(finalRequest, completionHandler: {(data: NSData!, response : NSURLResponse!, error: NSError!) -> Void in
            handler(response,data,error)
        })
        sessionTask.resume()
    }
    
    func stringForURL(url : NSURL, completionHandler handler: stringForURLCompletionClosure) {
        dataForURL(url, completionHandler: {(response : NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            handler(response,responseString,error)
        })
    }
    
    // MARK: NSURLSessionDelegate
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust)
            
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,credential)
        }
    }
}