//
//  ReviewWrtingVC.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/03.
//

import UIKit
import FirebaseDatabase

class ReviewWrtingVC: UIViewController {
    @IBOutlet weak var evoluationView: UIStackView!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passwords: UITextField!
    @IBOutlet weak var screenSize: UISegmentedControl!
    @IBOutlet weak var screenBrightness: UISegmentedControl!
    @IBOutlet weak var screenMasking: UISegmentedControl!
    @IBOutlet weak var sound: UISegmentedControl!
    @IBOutlet weak var seat: UISegmentedControl!
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var reviewUpload: UIButton!
    
    private let database = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        evoluationView.layer.cornerRadius = 14
        commentField.layer.cornerRadius = 14
        
    }
    
    func SegmentSelected(index: Int) -> String{
        
        var retVal = 0
        
        switch index{
        case 0:
            retVal = 1
        case 1:
            retVal = 2
        case 2:
            retVal = 3
        case 3:
            retVal = 4
        case 4:
            retVal = 5
    
        default:
            print("It couldn't be occur")
        }
        
        return String(retVal)
    }
    
    func getTotalNum() -> Int {

        var retVal = 0
        database.child("Total_Review_Number").observeSingleEvent(of: .value) {snapshot in
            retVal = snapshot.value as! Int
        }
        return retVal
    }
    
    @IBAction func reviewUploadPressed(_ sender: Any) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let current_date_string = formatter.string(from: Date())
        
        let sizeVar = SegmentSelected(index: screenSize.selectedSegmentIndex)
        let brightVar = SegmentSelected(index: screenBrightness.selectedSegmentIndex)
        let soundVar = SegmentSelected(index: sound.selectedSegmentIndex)
        let seatVar = SegmentSelected(index: seat.selectedSegmentIndex)
        
        let reviewData : [String: String?] = [
            "이름": userName.text,
            "비밀번호": passwords.text,
            "작성일": current_date_string,
            "스크린 크기": sizeVar,
            "스크린 밝기": brightVar,
            "사운드": soundVar,
            "좌석": seatVar,
            "코멘트": commentField.text
        ]
        
        let total_num = getTotalNum() + 1
        
        database.child("Total_Review_Num").setValue(total_num)
        
        database.child("Review").child("Review_\(total_num)").setValue(reviewData)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
