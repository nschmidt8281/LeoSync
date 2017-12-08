//
//  MediaCollectionViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/2/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class MediaCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    let user = Auth.auth().currentUser!
    let dataRef = Database.database()
    let storageRef = Storage.storage().reference()
    
    // MARK: Variables
    var imageIdentifications: [ImageInformation] = []
    var images: [UIImage] = []
    var photoCategories = PhotoCategory.fetchPhotos()
    var collectionViewWidth: CGFloat?
    var selectedIndexPath: IndexPath!
    
    struct Storyboard {
        static let MediaCollectionViewCell = "MediaCollectionViewCell"
        static let headerCell = "HeaderCell"
        static let showDetailSegue = "ShowDetail"
        
        static let leftAndRightPaddings: CGFloat = 2.0
        static let numberOfItemsPerRow: CGFloat = 3.0
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        
        ref.child("users/\(user.uid)").observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            self.navigationItem.title = value?["company"] as? String
        })
        
        dataRef.reference(withPath: "photos/\(user.uid)").queryLimited(toLast: 30).observe(.value, with: { snapshot in
            var newImages: [ImageInformation] = []
            
            for image in snapshot.children {
                let imageInformation = ImageInformation(snapshot: image as! DataSnapshot)
                newImages.append(imageInformation)
            }
            
            self.imageIdentifications = newImages
            self.collectionView?.reloadData()
        })
        
        let screenWidth = collectionView?.frame.width
        
        if screenWidth!.truncatingRemainder(dividingBy: 2) == 0 {
            self.collectionViewWidth = screenWidth!
        } else {
            self.collectionViewWidth = screenWidth! - 1.0
        }
        
        let itemWidth = (collectionViewWidth! - (Storyboard.leftAndRightPaddings)) / Storyboard.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    // MARK: Methods
    @IBAction func btnBack_Touch(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "userAccountHomePage")
        self.present(vc!, animated: true, completion: nil)
    }
    
    // MARK: UIColletionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageIdentifications.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.MediaCollectionViewCell, for: indexPath) as! MediaCollectionViewCell
        
        let imageIdentificaion = imageIdentifications[indexPath.row]
        let imageLocation = URL(string: imageIdentificaion.imageURL)
        URLSession.shared.dataTask(with: imageLocation!, completionHandler: { (data, response, error) in
            if error != nil {
                // ERROR
                return
            }
            
            DispatchQueue.main.async {
                cell.imgMedia?.image = UIImage(data: data!)
            }
        }).resume()
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? MediaCollectionViewCell
        let image = selectedCell?.imgMedia.image
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: Storyboard.showDetailSegue, sender: image)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showDetailSegue {
            let detailVC = segue.destination as! MediaDetailViewController
            
            detailVC.image = sender as! UIImage
        }
    }
}

/*
extension MediaDetailViewController : ZoomingViewController
{
    func zoomingBackgroundView(for transition: MediaZoomTransitionDelegate) -> UIView? {
        return nil
    }
    
    func zoomingImageView(for transition: MediaZoomTransitionDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            let cell = collectionView?.cellForItem(at: indexPath) as! MediaCollectionViewCell
            return cell.imgMedia
        }
    }
}
 */
