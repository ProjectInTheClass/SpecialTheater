//
//  TheaterSelectionViewController.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/01.
//

import UIKit

class DateLocationVC: UIViewController {
    @IBOutlet weak var movieInfoView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePiker: UIDatePicker!
    @IBOutlet weak var locationPickerVIew: UIView!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieInfoView.layer.cornerRadius = 14
        datePickerView.layer.cornerRadius = 14
        datePiker.minimumDate = Date()
        datePiker.maximumDate = Date().addingTimeInterval(TimeInterval(3600 * 24 * 7))
        locationPickerVIew.layer.cornerRadius = 14
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedItem = sender as? movieItem {
            self.posterImage.image = selectedItem.posterImage.image
        }
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
