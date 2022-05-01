//
//  movieItem.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/01.
//
import UIKit

class movieItem: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 14
        posterImage.layer.cornerRadius = 14
    }
}
