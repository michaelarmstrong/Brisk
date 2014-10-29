//
//  BriskClient.swift
//  Brisk
//
//  Created by Michael Armstrong on 05/06/2014.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation
import UIKit

class BriskClient: NSObject {
    
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
        var urlSession = NSURLSession(configuration:sessionConfiguration, delegate: nil, delegateQueue: queue)
        
        var sessionTask = urlSession.dataTaskWithRequest(request, completionHandler: {(data: NSData!, response : NSURLResponse!, error: NSError!) -> Void in
            handler(response,data,error)
        })
        sessionTask.resume()
    }
    
    func dataForURL(url : NSURL, postData: NSData, completionHandler handler: dataForURLCompletionClosure) {
        var request = NSMutableURLRequest(URL:url)
        var urlSession = NSURLSession(configuration:sessionConfiguration, delegate: nil, delegateQueue: queue)
        request.HTTPMethod = "POST"
        
        if(postData.length != 0){
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = postData
        }
        
        
        let finalRequest = request.copy() as NSURLRequest
        var sessionTask = urlSession.dataTaskWithRequest(finalRequest, completionHandler: {(data: NSData!, response : NSURLResponse!, error: NSError!) -> Void in
            handler(response,data,error)
        })
        sessionTask.resume()
    }
    
    func stringForURL(url : NSURL, completionHandler handler: stringForURLCompletionClosure) {
        dataForURL(url, completionHandler: {(response : NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            handler(response,responseString,error)
        })
    }
    
}