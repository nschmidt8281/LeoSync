
//
//  MediaDetailViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/6/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit

class MediaDetailViewController: UIViewController {

    // MARK: Variables
    var image: UIImage?
    
    // MARK: Properties
    
    // MARK: Outlets
    @IBOutlet weak var imgMediaDetail: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "LeoSync"
        
        self.imgMediaDetail.image = image

        /*
        URLSession.shared.dataTask(with: imageLocation!, completionHandler: { (data, response, error) in
            if error != nil {
                // ERROR
                return
            }
            DispatchQueue.main.async {
                self.imgMediaDetail.image = UIImage(data: data!)
            }
        })
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
