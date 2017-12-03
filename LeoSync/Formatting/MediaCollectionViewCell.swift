//
//  MediaCollectionViewCell.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/2/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgMedia: UIImageView!
 
    var imageName: String! {
        didSet {
            imgMedia.image = UIImage(named: imageName)
        }
    }
}
