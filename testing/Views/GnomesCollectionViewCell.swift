//
//  GnomesCollectionViewCell.swift
//  testing
//
//  Created by Familia Fonseca López on 06/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

class GnomesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gnomeThumbnail : UIImageView!
    @IBOutlet weak var nameTitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }

}
