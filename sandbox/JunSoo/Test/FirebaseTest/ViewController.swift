//
//  ViewController.swift
//  FirebaseTest
//
//  Created by JUNSOO LEE on 2022/05/17.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore


class ViewController: UIViewController{
    
    private let database = Database.database().reference()
    let db = Firestore.firestore()

    var read_data: Int = 0
    
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var Passwords: UITextField!
    @IBOutlet weak var Comment: UITextField!
    @IBOutlet weak var UploadButton: UIButton!
    @IBOutlet weak var ReadDataTextField: UITextField!
    @IBOutlet weak var Rates: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            print("It couldn't happen")
        }
        
        return String(retVal)
    }
    
    @IBAction func UbuttonPressed(_ sender: Any) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let current_date_string = formatter.string(from: Date())
        
        
        let name = NameInput.text
        let pw = Passwords.text
        let comment = Comment.text
        let rate = SegmentSelected(index:Rates.selectedSegmentIndex)
        
        let review_data: [String: Any?] = [
            "이름": name,
            "비밀번호": pw,
            "영화": "",
            "상영관": "",
            "평점": rate,
            "코멘트": comment,
            "작성일": current_date_string
        ]
        
    
        let docRef = db.collection("Review").document("Serial_num")
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                
                let property = document.get("number") as! Int
                
                self.read_data = property
                self.db.collection("Review").document("Review_\(self.read_data)").setData(review_data)
                self.db.collection("Review").document("Serial_num").setData(["number":self.read_data+1])
        
            } else {
                print ("Document does not exist!")
            }
            
        }
 
        
     /*
        database.child("Review_num").observeSingleEvent(of: .value){ snapshot in
            let value = snapshot.value as! Int
            self.read_data = value
            self.database.child("Review").child("Review_\(self.read_data)").setValue(review_data)
            self.database.child("Review_num").setValue(self.read_data+1)
        }*/
    }


    @IBAction func ReadDataButton(_ sender: Any) {
        
        let find_review = db.collection("Review").whereField("상영관", isEqualTo: "4DX").getDocuments(){ (QuerySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                    print("----\(document.data())----")
                }
            }
        }
        print(find_review)
     /*
        database.child("Review").child("Review_0").observeSingleEvent(of: .value){
            snapshot in
        
            d
            
            let value = snapshot.value as? NSDictionary
            let username = value?["이름"] as! String
            let rate = value?["평점"] as! String
            let comment = value?["코멘트"] as! String
    
            self.ReadDataTextField.text = "이름: " + username + "평점: " + rate + "코멘트: " + comment
          
        }*/
    }
}
