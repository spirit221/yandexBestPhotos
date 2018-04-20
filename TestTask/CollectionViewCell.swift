//
//  CollectionViewCell.swift
//  TestTask
//
//  Created by Sergey Gusev on 14.04.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func commonInit(data: UIImage) {
        imageCell.image = data
    }
}

