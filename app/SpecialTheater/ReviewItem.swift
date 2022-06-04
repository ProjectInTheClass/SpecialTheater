//
//  ReviewItem.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/06/04.
//

import UIKit

class ReviewItem: UITableViewCell {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func removeReview(_ sender: Any) {
    }
    
}
