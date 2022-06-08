//
//  TheaterSelectionVC.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/02.
//

import UIKit

class TheaterSelectionVC: UIViewController {
    // for prototype 1
    // @IBOutlet weak var detailView: UIView!
    // @IBOutlet weak var dateLocationView: UIView!
    // @IBOutlet weak var movieListTable: UITableView!
    
    // for prototype 2
    @IBOutlet weak var detailView2: UIView!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var theaterTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // for prototype 1
        // detailView.layer.cornerRadius = 14
        // dateLocationView.layer.cornerRadius = 14
        // movieListTable.layer.cornerRadius = 14
        
        // for prototype 2
        detailView2.layer.cornerRadius = 14
        posterImg.layer.cornerRadius = 14
        theaterTable.layer.cornerRadius = 14
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
