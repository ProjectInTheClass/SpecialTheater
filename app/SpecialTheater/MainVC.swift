//
//  ViewController.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/04/26.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 컬렉션뷰에 관한 초기 설정을 진행합니다.
        movieCollection.layer.cornerRadius = 14
        movieCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        movieCollection.dataSource = self
        movieCollection.delegate = self
        
        // 사용할 컬렉션뷰 셀을 등록합니다.
        let movieItemNib = UINib(nibName: String(describing: MovieItem.self), bundle: nil)
        self.movieCollection.register(movieItemNib, forCellWithReuseIdentifier: String(describing: MovieItem.self))
        self.movieCollection.collectionViewLayout = createCompositionalLayout()
    }
    
    // 화면을 터치하면 검색을 위해 올라왔던 키보드가 다시 내려갑니다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC: TheaterSelectionVC = segue.destination as? TheaterSelectionVC else { return }
        guard let cell: MovieItem = sender as? MovieItem else { return }
        let _ = destVC.view
        destVC.posterImg.image = cell.posterImageView.image
        destVC.selectedMovieTitle.text = cell.name
    }
    
}

// MARK: - Collection View Compositional Layout
extension MainVC {
    // 컬렉션뷰 레이아웃을 설정합니다.
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.414 / 2 + 0.1))
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
extension MainVC: UICollectionViewDataSource {
    // 컬렉션뷰에 표시할 셀의 개수를 리턴합니다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // indexPath번째에 표시할 셀을 리턴합니다.
    // movieItem 클래스에서 셀에 대한 설정이 이뤄집니다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieItem.self), for: indexPath) as! MovieItem
        cell.name = "닥터스트레인지: 대혼돈의 멀티버스"
        return cell
    }
}

// MARK: - Delegate
extension MainVC: UICollectionViewDelegate {
    // 셀을 선택하면 영화관 선택 뷰로 전환합니다.
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = self.movieCollection.cellForItem(at: indexPath) {
            performSegue(withIdentifier: "TheaterSelection", sender: cell)
        }
    }
}