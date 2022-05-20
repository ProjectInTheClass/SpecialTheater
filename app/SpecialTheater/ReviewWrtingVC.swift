//
//  ReviewWrtingVC.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/03.
//

import UIKit

class ReviewWrtingVC: UIViewController {
    @IBOutlet weak var evoluationView: UIStackView!
    @IBOutlet weak var commentFiled: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        evoluationView.layer.cornerRadius = 14
        commentFiled.layer.cornerRadius = 14
    }
    
    
    // 화면을 터치하면 검색을 위해 올라왔던 키보드가 다시 내려갑니다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
