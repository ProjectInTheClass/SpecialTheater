//
//  PopUpVC.swift
//  SpecialTheater
//
//  Created by JUNSOO LEE on 2022/06/08.
//

import UIKit
import FirebaseFirestore

class PopUpVC: UIViewController{
    
    // "비밀번호를 입력하세요" 입력창
    @IBOutlet weak var inputPassword: UITextField!
    // "틀린 비밀번호입니다. 다시 입력해주세요" 입력창
    @IBOutlet weak var wrongInputPassword: UITextField!
    // "비밀번호를 입력하세요" 확인버튼
    @IBOutlet weak var doneButton: UIButton!
    // "틀린 비밀번호입니다. 다시 입력해주세요" 확인버튼
    @IBOutlet weak var wrongDoneButton: UIButton!
    // "해당리뷰가 삭제되었습니다" 확인버튼
    @IBOutlet weak var deletedDoneButton: UIButton!
    
    let db = Firestore.firestore()
    var password: String = ""
    var reviewNum: String = ""
    var viewController: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PopUpVC - viewDidLoad() function called")
    }
    
    // "비밀번호를 입력하세요" 취소버튼 누를 때
    @IBAction func backButtonPressed(_ sender: Any) {
        print("PopUpVC - backButtonPressed function called")
        self.dismiss(animated: true, completion: nil)
    }
    // "틀린 비밀번호입니다. 다시 입력해주세요" 취소버튼 누를 때
    @IBAction func wrongBackButtonPressed(_ sender: Any) {
        print("PopUpVC - wrongBackButtonPressed function called")
        self.dismiss(animated: true, completion: nil)
    }
    
    // "비밀번호를 입력하세요" 확인버튼 누를 때
    @IBAction func doneButtonPressed(_ sender: Any) {
        print("PopUpVC - doneButtonPressed fucntion called")
        
        // 입력한 비밀번호가 해당 리뷰의 비밀번호랑 일치하지 않은 경우
        if(inputPassword.text != self.password){
            let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
            let alertPopUpVC = storyboard.instantiateViewController(withIdentifier: "WrongPassword") as! PopUpVC
            alertPopUpVC.password = self.password
            alertPopUpVC.reviewNum = self.reviewNum
            alertPopUpVC.modalPresentationStyle = .overCurrentContext
            alertPopUpVC.modalTransitionStyle = .crossDissolve
            guard let pvc = self.presentingViewController else {return}
            self.dismiss(animated: true){
                pvc.present(alertPopUpVC,animated: true, completion: nil)
            }
        }
        // 입력한 비밀번호랑 해당 리뷰의 비밀번호랑 일치하는 경우
        else{
            
            // 리뷰번호를 토대로 해당 리뷰를 삭제
            self.db.collection("Review").document(self.reviewNum).delete(){ err in
                if let err = err {
                        print("Error removing document: \(err)")
                } else {
                        print("Document successfully removed!")
                }
            }
            
            let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
            let alertPopUpVC = storyboard.instantiateViewController(withIdentifier: "ReviewDeleted") as! PopUpVC
            alertPopUpVC.password = self.password
            alertPopUpVC.reviewNum = self.reviewNum
            alertPopUpVC.modalPresentationStyle = .overCurrentContext
            alertPopUpVC.modalTransitionStyle = .crossDissolve
            guard let pvc = self.presentingViewController else {return}
    
            self.dismiss(animated: true){
                pvc.present(alertPopUpVC,animated: true, completion: nil)
            }
            
        }
    }
    // "틀린 비밀번호입니다. 다시 입력해주세요" 확인버튼 누를 때
    @IBAction func wrongButtonPressed(_ sender: Any) {
        
        if(self.wrongInputPassword.text != self.password){
            let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
            let alertPopUpVC = storyboard.instantiateViewController(withIdentifier: "WrongPassword") as! PopUpVC
            alertPopUpVC.password = self.password
            alertPopUpVC.reviewNum = self.reviewNum
            
            alertPopUpVC.modalPresentationStyle = .overCurrentContext
            alertPopUpVC.modalTransitionStyle = .crossDissolve
            guard let pvc = self.presentingViewController else {return}
            self.dismiss(animated: true){
                pvc.present(alertPopUpVC,animated: true, completion: nil)
            }
        }
        
        else{
            
            self.db.collection("Review").document(reviewNum).delete(){ err in
                if let err = err {
                        print("Error removing document: \(err)")
                } else {
                        print("Document successfully removed!")
                }
            }
            
            let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
            let alertPopUpVC = storyboard.instantiateViewController(withIdentifier: "ReviewDeleted") as! PopUpVC
            alertPopUpVC.modalPresentationStyle = .overCurrentContext
            alertPopUpVC.modalTransitionStyle = .crossDissolve
            guard let pvc = self.presentingViewController else {return}
            self.dismiss(animated: true){
                pvc.present(alertPopUpVC,animated: true, completion: nil)
            }
            
        }
    }
    
    // "해당 리뷰가 삭제되었습니다" 확인 버튼 누를 때
    @IBAction func deletedDonePressed(_ sender: Any) {
        guard let vc = self.viewController as? ReviewVC else { return }
        // vc.deleteReview()
        self.dismiss(animated: true, completion: nil)
    }
}


