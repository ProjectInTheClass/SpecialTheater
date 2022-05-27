//
//  SecondViewController.swift
//  FirebaseTest
//
//  Created by JUNSOO LEE on 2022/05/20.
//

import UIKit

class SecondViewController: UIViewController {
 
    @IBOutlet weak var Reviewer_Name: UILabel!
    @IBOutlet weak var Reviewer_Context: UITextField!
    @IBOutlet weak var Reviewer_Rate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Reviewer_Name.text = "Mr.red"
        Reviewer_Context.text = "It is a good place for watching horror movie"
        Reviewer_Rate.text = "3.5"
    }
}



