//
//  PreviewViewController.swift
//  OptisolTask
//
//  Created by Santhosh on 14/10/20.
//  Copyright © 2020 Contus. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    // Image passed from news list controller
    var image : UIImage!
    
    // Outlet to display the selected image
    @IBOutlet weak var previewImage : UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.previewImage.image = image
    }
    

   
}
