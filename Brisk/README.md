Brisk
=====================


A simple new Networking Framework written entirely in  **Swift** that wraps around `NSURLSession` and provides some convenience. This project is purely aimed as a Swift learning exercise for now and not a replacement or purposeful networking library. It should work on both OS X and iOS.

*Does it work?... Mostly*
*Does it have a lot of features?... No*
*Should I use it?... No*
*Should I contribute to it?... Sure*
*Should I learn from it?... Maybe*

----------


Built-ins
---------

**Brisk** comes with some convenience methods out the box and ready for you to use, additionally, included in the repo is an example project.



> **Whats missing / todo:**
> 
> - Ability to configure sessions for specific SSL/TLS needs (self-signed / invalid certs) and authentication.
> - Unit Tests and Good Error handling
> - Proper Framework namespacing and moduleisation
> - A well-thought out architecture

> **Whats working:**
> 
> - The ability to fetch data from remote servers via any supported protocol.
> - Extensibility via **Swift** extensions.
> - A delegate free, closure based architecture

Examples
---------
An example project is included in the repo, as mentioned, please don't use this in production, its purely educational / a place for me to play around with **Swift** but who knows... It could become great :)

#### Fetching Data

Simply `import Brisk` into your project and you're ready to go.

        var client = Brisk.client()
        var testURL = NSURL.URLWithString("http://www.google.com")
        client.dataForURL(testURL, completionHandler: {(response : NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
            println("Response Data: \(responseData)")
            })

#### Using an Extension (built-in or your own)

Right now, **Extensions** are used to provide the extensibility in **Swift** the Framework itself ships with a the `JSONExtension.swift` extension, that when passed a URL that will respond with a JSON payload, will return a homogenous `NSDictionary`.

        var anotherTestJSONURL = NSURL.URLWithString("http://whatever.com/superAmazing.json")
        client.dictionaryForURL(anotherTestJSONURL, completionHandler: {(response : NSURLResponse!, responseDictionary: NSDictionary!, error: NSError!) -> Void in
                if !error? {
                    println("Response Dictionary: \(responseDictionary)")
                } else {
                    println("Error : \(error)")
                }
            })




#### Using the Framework in another project

**Brisk** was built to be used this way, you can either drag it in as a dependant project, or better still link against the iOS / OS X framework that is built with the project.


----------

If you wanna contact me or have any suggestions, feedback, pull requests or just general discussion hit me up on the below

[http://mike.kz][1]

[@ArmstrongAtWork][2]


  [1]: http://mike.kz
  [2]: http://twitter.com/ArmstrongAtWork
