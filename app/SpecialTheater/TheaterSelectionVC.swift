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
    
    @IBOutlet weak var selecedMovieGenre: UILabel!
    @IBOutlet weak var CompanySeg: UISegmentedControl!
    
    let screenTypesOfCGV: [(String, String)] = [("LM", "CINE&LIVING ROOM"), ("103", "CINE de CHEF"), ("CF", "CINE&FORET"), ("CK", "CINE KIDS"), ("99", "GOLD CLASS"), ("07", "IMAX"), ("PRM", "PREMIUM"), ("pc", "THE PRIVATE CINEMA"), ("SCX", "SCREEN X"), ("SKY", "SKYBOX"), ("SDX", "SOUND X"), ("SPX", "SPHERE X"), ("110", "STARIUM"), ("SC", "SUITE CINEMA"), ("09", "SWEETBOX"), ("TEM", "TEMPUR CINEMA"), ("4D14", "4DX"), ("4DXSC", "4DX SCREEN")]
    
    let screenTypesOfLOTTECINEMA: [(String, String)] = [("300", "샤롯데"), ("950", "시네 비즈"), ("986", "시네 컴포트"), ("200", "시네 커플"), ("960", "시네 패밀리"), ("987", "시네 살롱"), ("988", "컬러리움"), ("930", "수퍼4D"), ("940", "수퍼플렉스"), ("941", "수퍼플렉스G"), ("980", "수퍼S"), ("400", "아르떼")]
    
    let screenTypesOfMEGABOX: [(String, String)] = [("CFT", "컴포트"), ("DBC", "돌비시네마"), ("MKB", "메가키즈"), ("MX", "MX"), ("TB", "더 부티크")]
    
    var theatersSelected : [String] = []
    
    var cgvSelected: [(String, String)] = []
    var lotteSelected: [(String, String)] = []
    var megaSelected: [(String, String)] = []
        
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
    
    // MARK: - 토스트 메시지
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC: ReviewVC = segue.destination as? ReviewVC else { return }
        guard let cell: TheaterItem = sender as? TheaterItem else { return }
        let _ = destVC.view
        destVC.movieInfoLabel.text = selectedMovieTitle.text
        destVC.theaterInfoLabel.text = cell.company + " " + cell.type
        destVC.theaterName = cell.type
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
        // Segment Control이 선택된 것에 따라 다른 수를 반환합니다.
        var numberOfItems = 0
        switch CompanySeg.selectedSegmentIndex {
        case 0:
            for cgv in screenTypesOfCGV {
                if theatersSelected.contains(cgv.0) {
                    numberOfItems += 1
                    cgvSelected.append(cgv)
                }
            }
            break
        case 1:
            for lotte in screenTypesOfLOTTECINEMA {
                if theatersSelected.contains(lotte.0) {
                    numberOfItems += 1
                    lotteSelected.append(lotte)
                }
            }
            break
        case 2:
            for mega in screenTypesOfMEGABOX {
                if theatersSelected.contains(mega.0) {
                    numberOfItems += 1
                    megaSelected.append(mega)
                }
            }
            break
        default:
            numberOfItems = 0
        }
        if numberOfItems == 0 {
            self.showToast(message: "상영관이 없어요 :(")
        }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Segment Control이 선택된 것에 따라 다른 셀을 반환합니다.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TheaterItem.self), for: indexPath) as! TheaterItem
        switch CompanySeg.selectedSegmentIndex {
        case 0:
            cell.company = "CGV"
            cell.type = cgvSelected[indexPath.row].1
            cell.theaterImage.image = UIImage(named: cgvSelected[indexPath.row].0)
            break
            
        case 1:
            cell.company = "롯데시네마"
            cell.type = lotteSelected[indexPath.row].1
            cell.theaterImage.image = UIImage(named: lotteSelected[indexPath.row].0)
            break
            
        case 2:
            cell.company = "메가박스"
            cell.type = megaSelected[indexPath.row].1
            cell.theaterImage.image = UIImage(named: megaSelected[indexPath.row].0)
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
