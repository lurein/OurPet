//
//  CollectionViewCell.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 7/14/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var walkedTodayLabel: UILabel!
    @IBOutlet weak var morningFedLabel: UILabel!
    @IBOutlet weak var eveningFedLabel: UILabel!
    @IBOutlet weak var petNameLabel: UILabel!
    
    // This resets the image when we reuse the cell
    override func prepareForReuse() {
        super.prepareForReuse()
        self.petImage.image = UIImage(named: "dog_avatar2")
        self.petImage.sd_cancelCurrentImageLoad()
    }
}
