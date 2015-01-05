//
//  JSONExtension.swift
//  Brisk
//
//  Created by Michael Armstrong on 08/06/2014.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation
import UIKit

let kKeyContent = "content"

extension BriskClient {
    
    typealias dictionaryForURLCompletionClosure = ((NSURLResponse!, NSDictionary?, NSError?) -> Void)!
    
    func dictionaryForURL(url : NSURL, completionHandler handler: dictionaryForURLCompletionClosure) {
        dataForURL(url, completionHandler: {(response : NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if error != nil {
                handler(response,nil,error)
                return
            }
            
            var resultDictionary = NSMutableDictionary()
            var deserializationError : NSError?
            
            var obj : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &deserializationError)
            
            if let jsonObject: AnyObject = obj {
                switch jsonObject {
                case is NSArray:
                    resultDictionary[kKeyContent] = jsonObject
                case is NSDictionary:
                    resultDictionary = NSMutableDictionary(dictionary: jsonObject as NSDictionary)
                default:
                    resultDictionary[kKeyContent] = ""
                }
            }
            handler(response,resultDictionary.copy() as? NSDictionary,error)
        })
    }
    
    func dictionaryForRequest(request : NSURLRequest, postParams : NSDictionary?, completionHandler handler: dictionaryForURLCompletionClosure) {
     
        var urlRequest = request
        
        if let postParams = postParams {
            var serializationError : NSError?
            let jsonData = NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions.PrettyPrinted, error: &serializationError)
            
            if(serializationError != nil){
                handler(nil,nil,serializationError)
            }
            
            let mutableRequest = urlRequest.mutableCopy() as NSMutableURLRequest
            
            if mutableRequest.HTTPMethod == "GET" {
                mutableRequest.HTTPMethod = "POST"
            }

            if let jsonData = jsonData {
                mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableRequest.HTTPBody = jsonData
            }
            urlRequest = mutableRequest.copy() as NSURLRequest
        }
        

        
        dataForRequest(urlRequest, completionHandler: {(response : NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        // TODO: Remove this MASSIVE amount of code duplication I just added and tidy up the almightly unneccesaryness of it.
            if error != nil {
                handler(response,nil,error)
                return
            }
            
            let resultString = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("Result String : \(resultString)")
            
            var deserializationError : NSError?
            var dataObj : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &deserializationError)
            
            if let resultObj = dataObj as? NSDictionary {
                if let resultDictionary = resultObj["Content"] as? NSDictionary {
                    handler(response,resultDictionary,error)
                } else {
                    if let resultArray = resultObj["Content"] as? NSArray {
                        let resultDictionary = [kKeyContent:resultArray]
                        handler(response,resultDictionary,error)
                        return
                    }
                    
                    var resultDictionary = NSMutableDictionary()
                    switch dataObj {
                    case is NSArray:
                        resultDictionary[kKeyContent] = dataObj
                    case is NSDictionary:
                        resultDictionary = NSMutableDictionary(dictionary: dataObj as NSDictionary)
                    default:
                        resultDictionary[kKeyContent] = ""
                    }
                    handler(response,resultDictionary,error)
                    return
                    
                    // handler(response,nil,error)
                }
                return
            } else {
                var resultDictionary = NSMutableDictionary()
                switch dataObj {
                case is NSArray:
                    resultDictionary[kKeyContent] = dataObj
                case is NSDictionary:
                    resultDictionary = dataObj as NSMutableDictionary
                default:
                    resultDictionary[kKeyContent] = ""
                }
                handler(response,resultDictionary,error)
                return
            }
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
            //println("Result String : \(resultString)")
            
            
            var deserializationError : NSError?
            var dataObj : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &deserializationError)
            
            if let resultObj = dataObj as? NSDictionary {
                if let resultDictionary = resultObj["Content"] as? NSDictionary {
                    handler(response,resultDictionary,error)
                } else {
                    if let resultArray = resultObj["Content"] as? NSArray {
                        let resultDictionary = [kKeyContent:resultArray]
                        handler(response,resultDictionary,error)
                        return
                    }
                    
                    var resultDictionary = NSMutableDictionary()
                    switch dataObj {
                    case is NSArray:
                        resultDictionary[kKeyContent] = dataObj
                    case is NSDictionary:
                        resultDictionary = NSMutableDictionary(dictionary: dataObj as NSDictionary)
                    default:
                        resultDictionary[kKeyContent] = ""
                    }
                    handler(response,resultDictionary,error)
                    return
                    
                    // handler(response,nil,error)
                }
                return
            } else {
                var resultDictionary = NSMutableDictionary()
                switch dataObj {
                case is NSArray:
                    resultDictionary[kKeyContent] = dataObj
                case is NSDictionary:
                    resultDictionary = dataObj as NSMutableDictionary
                default:
                    resultDictionary[kKeyContent] = ""
                }
                handler(response,resultDictionary,error)
                return
            }
        })
    }
    
}