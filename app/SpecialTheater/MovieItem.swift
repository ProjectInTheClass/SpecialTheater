//
//  movieItem.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/01.
//
import UIKit

class MovieItem: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 14
        posterImage.layer.cornerRadius = 14
    }
}
