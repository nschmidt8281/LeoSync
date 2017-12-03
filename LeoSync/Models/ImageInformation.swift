//
//  ImageInformation.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/3/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import Foundation
import Firebase

struct ImageInformation {
    
    let key: String
    let imageID: Int
    let imagePath: String
    let imageURL: String
    let ref: DatabaseReference?
    
    init(imageID: Int, imagePath: String, imageURL: String, key: String = "") {
        self.key = key
        self.imageID = imageID
        self.imagePath = imagePath
        self.imageURL = imageURL
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String : AnyObject]
        imageID = snapshotValue["imageID"] as! Int
        imagePath = snapshotValue["imagePath"] as! String
        imageURL = snapshotValue["imageURL"] as! String
        ref = snapshot.ref
    }
}
