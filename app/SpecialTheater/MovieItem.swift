//
//  movieItem.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/01.
//
import UIKit

class MovieItem: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    
    // Data which are deliverd to TheaterSelection View.
    var name: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 14
        self.posterImageView.layer.cornerRadius = 14
    }
}
