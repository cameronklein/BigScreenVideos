//
//  NetworkController.swift
//  BigScreenVideos
//
//  Created by Cameron Klein on 9/15/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit

enum SortStyle : String
{
    case Hot            = "hot"
    case New            = "new"
    case Controversial  = "controversial"
}

class NetworkController {
    
    static let baseURL = "https://reddit.com/r/"
    
    class func getVideosFromSubreddit(subreddit: String, sortedBy sortStyle: SortStyle, successHandler: (json: NSDictionary) -> (Void), failureHandler:(errorDescription: String) -> (Void))
    {
        let urlString = baseURL + subreddit + "/" + sortStyle.rawValue + ".json"
        let url = NSURL(string: urlString)
        
        guard let requestURL = url else {
            failureHandler(errorDescription: "URL failed")
            return
        }
        
        let request = NSURLRequest(URL: requestURL)
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            if let myError = error {
                failureHandler(errorDescription: myError.description)
            }
            
            guard let myResponse = response as? NSHTTPURLResponse else {
                failureHandler(errorDescription: "No response")
                return
            }
            
            switch myResponse.statusCode {
            case 200...299:
                
                guard let myData = data else {
                    failureHandler(errorDescription: "Data error")
                    return
                }
                
                if let json = try? NSJSONSerialization.JSONObjectWithData(myData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary {
                    successHandler(json: json)
                }
                
            default:
                failureHandler(errorDescription: "Something went wrong")
            }
        }
        
        dataTask.resume()
    }

}
