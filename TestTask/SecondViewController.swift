//
//  SecondViewController.swift
//  TestTask
//
//  Created by Sergey Gusev on 14.04.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageFrom:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageFrom
        // Do any additional setup after loading the view.
    }
    func commonInit(image: UIImage) {
       imageFrom = image
    }
//    deinit {
//        print("deinit SecondViewController")
//    }

}
