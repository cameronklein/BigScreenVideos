//
//  VideosCollectionViewCell.swift
//  BigScreenVideos
//
//  Created by Cameron Klein on 9/19/15.
//  Copyright © 2015 Cameron Klein. All rights reserved.
//

import UIKit

class VideosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:           UIImageView!
    @IBOutlet weak var descriptionLabel:    UILabel!

    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        self.imageView.transform =  self.focused ? CGAffineTransformMakeScale(1.5, 1.5) :CGAffineTransformIdentity
    }

    
}
