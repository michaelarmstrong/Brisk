//
//  JSONExtension.swift
//  Brisk
//
//  Created by Michael Armstrong on 08/06/2014.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation
import Brisk
import UIKit

let kKeyContent = "content"

extension BriskClient {
    
    typealias dictionaryForURLCompletionClosure = ((NSURLResponse!, NSDictionary!, NSError!) -> Void)!
    
    func dictionaryForURL(url : NSURL, completionHandler handler: dictionaryForURLCompletionClosure) {
        dataForURL(url, completionHandler: {(response : NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if error != nil {
                handler(response,nil,error)
                return
            }
            
            var resultDictionary = NSMutableDictionary()
            var deserializationError : NSError?
            
            var obj : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &deserializationError)!
            
            switch obj {
            case is NSArray:
                resultDictionary[kKeyContent] = obj
            case is NSDictionary:
                resultDictionary = obj as NSMutableDictionary
            default:
                resultDictionary[kKeyContent] = ""
            }
            handler(response,resultDictionary.copy() as NSDictionary,error)
        })
    }
    
    func dictionaryForURL(url : NSURL, postParams : NSDictionary, completionHandler handler: dictionaryForURLCompletionClosure) {
        var serializationError : NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions.PrettyPrinted, error: &serializationError)
        
        println("Post Params \(postParams)")
        
        if(serializationError != nil){
            handler(nil,nil,serializationError)
        }
        
        dataForURL(url, postData: jsonData!, completionHandler: {(response : NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if error != nil {
                handler(response,nil,error)
                return
            }
            
            let resultString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Result String : \(resultString)")
            
            var deserializationError : NSError?
            var dataObj : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &deserializationError)!
            
            if let resultObj = dataObj as? NSDictionary {
                if let resultDictionary = resultObj["Content"] as? NSDictionary {
                    handler(response,resultDictionary,error)
                } else {
                    if let resultArray = resultObj["Content"] as? NSArray {
                        let resultDictionary = [kKeyContent:resultArray]
                        handler(response,resultDictionary,error)
                        return
                    }
                    handler(response,nil,error)
                }
                return
            }
        })
    }
    
}