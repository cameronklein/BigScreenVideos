//
//  VideosDataSource.swift
//  BigScreenVideos
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit

class VideosDataSource : NSObject, UICollectionViewDataSource {
    
    var videos = [Video]()
    
    func loadVideosFromSubreddit(subreddit: String, completionHandler: Void -> (Void)) {
        NetworkController.getVideosFromSubreddit(subreddit, sortedBy: .Hot, successHandler: { (json) -> (Void) in
            
            self.videos = Video.videosFromJSON(json)
            completionHandler()
            
            }) { (errorDescription) -> (Void) in
                
                print(errorDescription)
                
        }
    }
    
    func urlForVideoAtIndex(index : Int) -> NSURL {
        return self.videos[index].videoURL
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Video Cell", forIndexPath: indexPath) as! VideosCollectionViewCell
        let video = videos[indexPath.row]
        
        video.requestImageWithCompletionHandler { (image) -> Void in
            cell.imageView.image = image;
        }
        
        cell.descriptionLabel.text = video.title
        
        return cell
    }

}
