//
//  CommonDetailCollectionViewCell.swift
//  testing
//
//  Created by Eduardo Fonseca on 12/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

class CommonDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var conceptTitle : UILabel!
    @IBOutlet weak var conceptIcon : UIImageView!
    @IBOutlet weak var conceptSubtitle : UILabel!
    @IBOutlet weak var titleSection : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }

}
