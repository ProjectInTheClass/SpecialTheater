//
//  ViewController.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/04/26.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 컬렉션뷰에 관한 초기 설정을 진행합니다.
        collectionView.layer.cornerRadius = 14
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 사용할 컬렉션뷰 셀을 등록합니다.
        let movieItemNib = UINib(nibName: String(describing: movieItem.self), bundle: nil)
        self.collectionView.register(movieItemNib, forCellWithReuseIdentifier: String(describing: movieItem.self))
        self.collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    // 화면을 터치하면 검색을 위해 올라왔던 키보드가 다시 내려갑니다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


// MARK: - Collection View Compositional Layout
extension ViewController {
    // 컬렉션뷰 레이아웃을 설정합니다.
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.414 / 2 + 0.14))
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
extension ViewController: UICollectionViewDataSource {
    // 컬렉션뷰에 표시할 셀의 개수를 리턴합니다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // indexPath번째에 표시할 셀을 리턴합니다.
    // movieItem 클래스에서 셀에 대한 설정이 이뤄집니다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: movieItem.self), for: indexPath) as! movieItem
        return cell
    }
}

// MARK: - Delegate
extension ViewController: UICollectionViewDelegate {
    // 여기서 셀에 관한 동작이 정의됩니다.
}
