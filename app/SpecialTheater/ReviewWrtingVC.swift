//
//  ReviewWrtingVC.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/03.
//

import UIKit
import FirebaseFirestore

class ReviewWrtingVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var evaluationItemsStackView: UIStackView!
    
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var passwords: UITextField!
    @IBOutlet weak var screenSize: UISegmentedControl!
    @IBOutlet weak var screenQuality: UISegmentedControl!
    @IBOutlet weak var sound: UISegmentedControl!
    @IBOutlet weak var seat: UISegmentedControl!
    @IBOutlet weak var mood: UISegmentedControl!
    @IBOutlet weak var comment: UITextField!
    
    var movieName: String = ""
    var theaterName: String = ""
    
    private let db = Firestore.firestore()
    private var readNum : Int = 0 // 리뷰 데이터 넘버링
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.evaluationItemsStackView.layer.cornerRadius = 14
        registerForKeyboardNotifications()

        self.scrollView.delegate = self
    }

    // MARK: - Scrolling with Keyboard
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_ :)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWhillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification:NSNotification) {
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWhillHide(_ notification:NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func upload() {
        // 리뷰 작성시간
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let currentDate = formatter.string(from: Date())
        
        let userName = nickname.text
        let userPw = passwords.text
        let userComment = comment.text
        let sizeRate = screenSize.selectedSegmentIndex + 1
        let qualityRate = screenQuality.selectedSegmentIndex + 1
        let soundRate = sound.selectedSegmentIndex + 1
        let seatRate = seat.selectedSegmentIndex + 1
        let moodRate = mood.selectedSegmentIndex + 1
        
        // 리뷰데이터를 딕셔너리 형태로 저장
        let reviewData: [String: Any?] = [
            "닉네임": userName,
            "비밀번호": userPw,
            "작성일": currentDate,
            "영화": self.movieName,
            "상영관": self.theaterName,
            "스크린 크기": sizeRate,
            "스크린 선명도": qualityRate,
            "사운드": soundRate,
            "좌석": seatRate,
            "분위기": moodRate,
            "코멘트": userComment
        ]
        // 리뷰데이터를 작성한 순서대로 정렬하기 위해 각 리뷰데이터의 document에 넘버링
        let docRef = db.collection("Review").document("Serial_num")
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists{
                let property = document.get("number") as! Int
                self.readNum = property
                self.db.collection("Review").document("Review_\(self.readNum)").setData(reviewData as [String : Any]) // 리뷰데이터 저장
                self.db.collection("Review").document("Serial_num").setData(["number":self.readNum+1]) // DB 내 number 증가
            }
            else{
                print ("Document does not exist!")
            }
        }
    }
}

extension ReviewWrtingVC: UIScrollViewDelegate {
    // 키보드가 올라온 상태에서 화면을 터치했을 때, 키보드를 내립니다.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
