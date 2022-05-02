//
//  TheaterSelectionVC.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/02.
//

import UIKit

class TheaterSelectionVC: UIViewController {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var dateLocationView: UIView!
    @IBOutlet weak var movieListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailView.layer.cornerRadius = 14
        dateLocationView.layer.cornerRadius = 14
        movieListTable.layer.cornerRadius = 14
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
