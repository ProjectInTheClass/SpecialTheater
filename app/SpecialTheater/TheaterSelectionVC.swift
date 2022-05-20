//
//  TheaterSelectionVC.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/02.
//

import UIKit

class TheaterSelectionVC: UIViewController {
    
    @IBOutlet weak var detailView2: UIView!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var theaterCollection: UICollectionView!
    @IBOutlet weak var descLabel: UILabel!
    
    enum screenTypesOfCGV: CaseIterable {
        case CINE_AND_LIVING_ROOM, CINE_DE_CHEF, CINE_FORET, CINE_KIDS, GOLD_CLASS, IMAX, PREMIUM, PRIVATE_CINEMA, SCREEN_X, SKY_BOX, SOUND_X, SPHERE_X, STARIUM, SUITE_CINEMA, SWEETBOX, TEMPUR_CINEMA, _4DX, _4DX_SCREEN, SUBPAC, VEATBOX, BRAND_COLLABORATION
    }
    
    enum screenTypesOfLOTTECINEMA: CaseIterable {
        case CHARLOTTE, CINE_BIZ, CINE_COMFORT, CINE_COUPLE, CINE_FAMILY, CINE_SALON, COLORIUM, SUPER_4D, SUPER_FLEX, SUPER_FLEX_G, SUPER_S
    }
    
    enum scrrenTypesOfMEGABOX: CaseIterable {
        case COMFORT, DOLBY_CINEMA, MEGA_KIDS, MX, THE_BOUTIQUE, THE_BOUTIQUE_PRIVATE
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView2.layer.cornerRadius = 14
        posterImg.layer.cornerRadius = 14
        
        // 사용할 컬렉션뷰 셀을 등록합니다.
        let theaterItemNib = UINib(nibName: String(describing: TheaterItem.self), bundle: nil)
        self.theaterCollection.register(theaterItemNib, forCellWithReuseIdentifier: String(describing: TheaterItem.self))
        self.theaterCollection.collectionViewLayout = createCompositionalLayout()
        
        // 컬렉션뷰에 관한 초기 설정을 진행합니다.
        theaterCollection.layer.cornerRadius = 14
        theaterCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        theaterCollection.dataSource = self
        theaterCollection.delegate = self
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Hi")
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let recievedData = sender as? (UIImage?, String?) {
            if let posterImage = recievedData.0 {
                posterImg.image = posterImage
            }
            if let desc = recievedData.1 {
                descLabel.text = desc
            }
        }
    }

}

// MARK: - Collection View Compositional Layout
extension TheaterSelectionVC {
    // 컬렉션뷰 레이아웃을 설정합니다.
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            let item = NSCollectionLayoutItem(layoutSize: itemsize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7)
            let groupHeight = itemsize.heightDimension
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7)
            return section
        }
        return layout
    }
}

// MARK: - Data Source
extension TheaterSelectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: - Segment Control이 선택된 것에 따라 다른 수를 반환합니다.
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: - Segment Control이 선택된 것에 따라 다른 셀을 반환합니다.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TheaterItem.self), for: indexPath) as! TheaterItem
        return cell
    }
}

// MARK: - Delegate
extension TheaterSelectionVC: UICollectionViewDelegate {
    // 셀을 선택하면 리뷰 뷰로 이동합니다.
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Review", sender: nil)
    }
}
