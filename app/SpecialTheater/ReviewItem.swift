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
    
    weak var reviewVC: ReviewVC?
    var reviewNum: String = ""
    var password: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func removeReview(_ sender: Any) {
        guard let vc = reviewVC else {
            print("리뷰 아이템 셀에서 리뷰 뷰 컨트롤러를 찾을 수 없습니다.")
            return
        }
        vc.deleteReview(reviewNum: reviewNum, password: password)
    }
    
    @IBAction func reportReview(_ sender: Any) {
        guard let vc = reviewVC else {
            print("리뷰 아이템 셀에서 리뷰 뷰 컨트롤러를 찾을 수 없습니다.")
            return
        }
        vc.reportReview(reviewNum: reviewNum)
    }
}
