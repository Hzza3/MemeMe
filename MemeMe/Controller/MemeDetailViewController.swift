//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Epic Systems on 1/29/19.
//  Copyright © 2019 AhmedHazzaa. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var memedImage = UIImage()
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }


}
