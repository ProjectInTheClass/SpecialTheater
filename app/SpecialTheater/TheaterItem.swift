//
//  ThearterItem.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/17.
//

import UIKit

class TheaterItem: UICollectionViewCell {

    @IBOutlet weak var theaterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 14
        self.theaterImage.layer.cornerRadius = 14
    }

}
