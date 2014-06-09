//
//  JSONOperation.swift
//  Brisk
//
//  Created by Michael Armstrong on 08/06/2014.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation
import Brisk

extension Client {
    
    typealias dictionaryForURLCompletionClosure = ((NSURLResponse!, NSDictionary!, NSError!) -> Void)!
    
    func dictionaryForURL(url : NSURL, completionHandler handler: dictionaryForURLCompletionClosure) {
        dataForURL(url, completionHandler: {(response : NSURLResponse!, data: NSData!, error: NSError!) -> Void in

            if error? {
                handler(response,nil,error)
                return
            }
            
            var resultDictionary = NSMutableDictionary()
            var deserializationError : NSError?
            
            var obj : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &deserializationError)
            
            switch obj {
                case is NSArray:
                    resultDictionary["content"] = obj
                case is NSDictionary:
                    resultDictionary = obj as NSMutableDictionary
                default:
                    resultDictionary["content"] = ""
            }
            handler(response,resultDictionary.copy() as NSDictionary,error)
            })
    }
    
}
