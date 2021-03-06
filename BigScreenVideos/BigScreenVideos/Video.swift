//
//  Video.swift
//  BigScreenVideos
//
//  Created by Cameron Klein on 9/15/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit

class Video {
    
    let title               : String
    let videoURL            : NSURL
    let thumbnailURL        : NSURL
    var image               : UIImage?
    
    init(title: String, videoURL: NSURL, thumbnailURL: NSURL)
    {
        self.title = title;
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
    }
    
    class func videosFromJSON(json: NSDictionary) -> [Video]
    {
        var array = [Video]()
        
        guard let data = json["data"] as? NSDictionary else {
            return array
        }
        
        guard let children = data["children"] as? NSArray else {
            return array
        }
        
        for child in children {
            
            guard let videoData = child["data"] as? NSDictionary else {
                break
            }
            
            guard let title = videoData["title"] as? String else {
                break
            }
            
            guard let videoString = videoData["url"] as? String else {
                break
            }
            
            guard let thumbString = videoData["thumbnail"] as? String else {
                break
            }
            
            let httpsString = videoString.stringByReplacingOccurrencesOfString("http", withString: "https")
            
            guard let videoURL = NSURL(string: httpsString) else {
                break
            }
            
            guard let domain = videoURL.host else {
                break
            }
            
            guard domain.rangeOfString("youtu") != nil else {
                break
            }
            
            guard let thumbURL = NSURL(string: thumbString) else {
                break
            }
            
            array.append(Video(title: title, videoURL: videoURL, thumbnailURL: thumbURL))
        }
        
        return array
    }
    
    func requestImageWithCompletionHandler(completionHandler: UIImage -> Void) {
        
        if let existingImage = image {
            completionHandler(existingImage)
            return
        }
        
        guard let myData = NSData(contentsOfURL: thumbnailURL) else {
            self.image = UIImage()
            completionHandler(self.image!)
            return
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            self.image = UIImage(data: myData)
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(self.image!)
            }
        }
    }

}

