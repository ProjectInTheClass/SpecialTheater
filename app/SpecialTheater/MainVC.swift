//
//  ViewController.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/04/26.
//

import UIKit
import FirebaseFirestore

class MainVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    
    struct Movie {
        let movietitle: String
        let posterurl: String
        let moviegenre: String
        let playingtheaters: [String]
    }
    var movies: [Movie] = []
    var moviesFiltered: [Movie] = []
    
    private let db = Firestore.firestore()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 컬렉션뷰에 관한 초기 설정을 진행합니다.
        movieCollection.layer.cornerRadius = 14
        movieCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        movieCollection.dataSource = self
        movieCollection.delegate = self
        
        searchBar.delegate = self
        
        // 최초 movies리스트 1회 가져오기 및 Filtered 리스트 초기화
        loadMovieNameAndPoster()
        
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
        destVC.selectedMovieTitle.text = cell.movieLabel.text
        for movie in movies {
            if cell.movieLabel.text == movie.movietitle {
                destVC.selecedMovieGenre.text = movie.moviegenre
            }
        }
    }
    
    func loadMovieNameAndPoster() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let current_date_string = formatter.string(from: Date())
        print(current_date_string)
        
        self.movies = []
        db.collection(current_date_string).addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("리뷰 데이터를 가져오는데 실패했습니다.")
                return
            }
            for document in documents {
                let data = document.data()
                guard let movietitle = data["name"] as? String else { continue }
                guard let posterurl = data["poster"] as? String else { continue }
                guard let moviegenre = data["genre"] as? String else { continue }
                guard let playingtheaters = data["types"] as? [String] else { continue }
                let movie = Movie(movietitle: movietitle,
                                  posterurl: posterurl,
                                  moviegenre: moviegenre,
                                  playingtheaters: playingtheaters)
                self.movies.append(movie)
                print("영화 데이터가 추가됐습니다.")
                print(movie)
            }
            print("영화 데이터를 모두 가져왔습니다.")
            print("영화 테이블의 데이터를 반영합니다.")
            self.moviesFiltered = self.movies
            self.movieCollection.reloadData()
            print(self.movies.count)
        }
    }
    
}

// MARK: - Searchbar delegate
extension MainVC: UISearchBarDelegate {
    
    // identifier
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        moviesFiltered = []

        if searchText == "" {
            moviesFiltered = movies
        } else {
            for movie in movies {
                if movie.movietitle.lowercased().contains(searchText.lowercased()) {
                    moviesFiltered.append(movie)
                }
            }
        }
        self.movieCollection.reloadData()
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
        return moviesFiltered.count
    }
    
    // indexPath번째에 표시할 셀을 리턴합니다.
    // movieItem 클래스에서 셀에 대한 설정이 이뤄집니다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieItem.self), for: indexPath) as! MovieItem
        
        let url = URL(string: moviesFiltered[indexPath.row].posterurl)
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.posterImageView.image = image
                    }
                }
            }
        }
        
        
        
        cell.movieLabel.text = moviesFiltered[indexPath.row].movietitle
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
