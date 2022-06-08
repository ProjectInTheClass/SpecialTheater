//
//  ReviewVC.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/03.
//

import UIKit

class ReviewVC: UIViewController {
    @IBOutlet weak var movieInfoView: UIView!
    @IBOutlet weak var theaterInfoView: UIView!
    @IBOutlet weak var reviewTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieInfoView.layer.cornerRadius = 14
        theaterInfoView.layer.cornerRadius = 14
        reviewTable.layer.cornerRadius = 14
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
