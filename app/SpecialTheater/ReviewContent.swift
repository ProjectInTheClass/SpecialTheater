//
//  ReviewContent.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/06/04.
//

import UIKit

class ReviewContent: UITableViewCell {
    @IBOutlet weak var screenSizeLabel: UILabel!
    @IBOutlet weak var screenQualityLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
