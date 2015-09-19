//
//  FirstViewController.swift
//  BigScreenVideos
//
//  Created by Cameron Klein on 9/15/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit
import AVKit

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var titleLabel:          UILabel!
    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var collectionView:      UICollectionView!
    
    let playerViewController = AVPlayerViewController()
    let videosDataSource     = VideosDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(playerViewController)
        playerViewController.didMoveToParentViewController(self)
        playerContainerView.addSubview(playerViewController.view)
        playerViewController.view.frame = playerContainerView.bounds
        
        playerViewController.showsPlaybackControls = true
        
        collectionView.registerNib(UINib(nibName: "VideosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Video Cell")
        
        collectionView.dataSource = videosDataSource
        collectionView.delegate   = self
        
        videosDataSource.loadVideosFromSubreddit("Videos") {
            
            self.collectionView.reloadData()
        }
    }
    
    func playVideoAtURL(url : NSURL) {
        
        guard let videoDictionary = HCYoutubeParser.h264videosWithYoutubeURL(url) else { return }
        
        guard let videoUrlString = videoDictionary["medium"] as? String else { return }
        
        guard let videoURL = NSURL(string: videoUrlString) else { return }
        
        let player : AVPlayer = AVPlayer(URL: videoURL)
        
        self.playerViewController.player = player
        self.playerViewController.view.autoresizesSubviews = true
        
        player.play()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerViewController.view.frame = self.playerContainerView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(collectionView.bounds.height - 16, collectionView.bounds.height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.playVideoAtURL(videosDataSource.urlForVideoAtIndex(indexPath.row))
    }
    
}

