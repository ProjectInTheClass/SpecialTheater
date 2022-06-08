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
    
    weak var viewController: UIViewController?
    
    var password: String = ""
    var reviewNum: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func removeReview(_ sender: Any) {
        print("ReviewItem - removeReview function called")
        // print("Password: \(password)");
        // print("ReviewNum: \(ReviewNum)");
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        let alertPopUpVC = storyboard.instantiateViewController(withIdentifier: "EnterPassword") as! PopUpVC
        alertPopUpVC.password = self.password
        alertPopUpVC.reviewNum = self.reviewNum
        alertPopUpVC.modalPresentationStyle = .overCurrentContext
        alertPopUpVC.modalTransitionStyle = .crossDissolve
        
        viewController?.present(alertPopUpVC, animated: true, completion: nil)
    }
    
}
