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
    @IBOutlet weak var selectedMovieTitle: UILabel!
    @IBOutlet weak var CompanySeg: UISegmentedControl!
    
    let screenTypesOfCGV: [(String, String)] = [("CINE_AND_LIVING_ROOM", "CINE&LIVING ROOM"), ("CINE_DE_CHEF", "CINE de CHEF"), ("CINE_FORET", "CINE&FORET"), ("CINE_KIDS", "CINE KIDS"), ("GOLD_CLASS", "GOLD CLASS"), ("IMAX", "IMAX"), ("PREMIUM", "PREMIUM"), ("PRIVATE_CINEMA", "THE PRIVATE CINEMA"), ("SCREEN_X", "SCREEN X"), ("SKY_BOX", "SKYBOX"), ("SOUND_X", "SOUND X"), ("SPHERE_X", "SPHERE X"), ("STARIUM", "STARIUM"), ("SUITE_CINEMA", "SUITE CINEMA"), ("SWEETBOX", "SWEETBOX"), ("TEMPUR_CINEMA", "TEMPUR CINEMA"), ("_4DX", "4DX"), ("_4DX_SCREEN", "4DX SCREEN"), ("SUBPAC", "SUBPAC"), ("VEATBOX", "VEATBOX"), ("BRAND_COLLABORATION", "BRAND COLLABORATION")]
    
    let screenTypesOfLOTTECINEMA: [(String, String)] = [("CHARLOTTE", "샤롯데"), ("CINE_BIZ", "시네비즈"), ("CINE_COMFORT", "시네 컴포트"), ("CINE_COUPLE", "시네 커플"), ("CINE_FAMILY", "시네 패밀리"), ("CINE_SALON", "시네 샬롱"), ("COLORIUM", "컬러리움"), ("SUPER_4D", "수퍼4D"), ("SUPER_FLEX", "수퍼플렉스"), ("SUPER_FLEX_G", "수퍼플렉스G"), ("SUPER_S", "수퍼S")]
    
    let screenTypesOfMEGABOX: [(String, String)] = [("COMFORT", "컴포트"), ("DOLBY_CINEMA", "돌비시네마"), ("MEGA_KIDS", "메가키즈"), ("MX", "MX"), ("THE_BOUTIQUE", "더 부티크"), ("THE_BOUTIQUE_PRIVATE", "더 부티크 프라이빗")]
    
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
    
    @IBAction func companySelectionChanged(_ sender: Any) {
        self.theaterCollection.reloadData()
        self.theaterCollection.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC: ReviewVC = segue.destination as? ReviewVC else { return }
        guard let cell: TheaterItem = sender as? TheaterItem else { return }
        let _ = destVC.view
        destVC.movieInfoLabel.text = selectedMovieTitle.text
        destVC.theaterInfoLabel.text = cell.company + " " + cell.type
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
        var numberOfItems = 0
        switch CompanySeg.selectedSegmentIndex {
        case 0:
            numberOfItems = screenTypesOfCGV.count
            break
        case 1:
            numberOfItems = screenTypesOfLOTTECINEMA.count
            break
        case 2:
            numberOfItems = screenTypesOfMEGABOX.count
            break
        default:
            numberOfItems = 0
        }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: - Segment Control이 선택된 것에 따라 다른 셀을 반환합니다.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TheaterItem.self), for: indexPath) as! TheaterItem
        switch CompanySeg.selectedSegmentIndex {
        case 0:
            cell.company = "CGV"
            cell.type = screenTypesOfCGV[indexPath.row].1
            cell.theaterImage.image = UIImage(named: screenTypesOfCGV[indexPath.row].0)
            break
        case 1:
            cell.company = "롯데시네마"
            cell.type = screenTypesOfLOTTECINEMA[indexPath.row].1
            cell.theaterImage.image = UIImage(named: screenTypesOfLOTTECINEMA[indexPath.row].0)
            break
        case 2:
            cell.company = "메가박스"
            cell.type = screenTypesOfMEGABOX[indexPath.row].1
            cell.theaterImage.image = UIImage(named: screenTypesOfMEGABOX[indexPath.row].0)
            break
        default:
            print("Invalid Segment Control", indexPath)
        }
        return cell
    }
}

// MARK: - Delegate
extension TheaterSelectionVC: UICollectionViewDelegate {
    // 셀을 선택하면 리뷰 뷰로 이동합니다.
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = self.theaterCollection.cellForItem(at: indexPath) as? TheaterItem {
            performSegue(withIdentifier: "Review", sender: cell)
        }
    }
}
