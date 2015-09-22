//
//  MemeDetailViewController.swift
//  MemeMeV1
//
//  Created by Petrik on 22/09/15.
//  Copyright © 2015 Peter Krajcir. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = meme!.memedImage
    }

}
