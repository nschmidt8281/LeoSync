//
//  HeaderCollectionReusableView.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/2/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: Outlets
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    
    // MARK: Variables
    var category: PhotoCategory! {
        didSet {
            lblCategory.text = category.title
            imgCategory.image = UIImage(named: category.categoryImageName)
        }
    }
    
}
