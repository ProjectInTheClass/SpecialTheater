//
//  ReviewVC.swift
//  SpecialTheater
//
//  Created by taejeong on 2022/05/03.
//

import UIKit
import FirebaseFirestore

class ReviewVC: UIViewController {
    @IBOutlet weak var movieInfoView: UIView!
    @IBOutlet weak var theaterInfoView: UIView!
    @IBOutlet weak var movieInfoLabel: UILabel!
    @IBOutlet weak var theaterInfoLabel: UILabel!
    @IBOutlet weak var reviewTable: UITableView!
    
    struct Review {
        let nickname: String
        let password: String
        let reviewNum: String
        let datetime: String
        let comment: String
        let screenSize: Int
        let screenQuality: Int
        let sound: Int
        let seat: Int
        let mood: Int
        var isOpen: Bool
    }
    var reviews: [Review] = []
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        movieInfoView.layer.cornerRadius = 14
        theaterInfoView.layer.cornerRadius = 14
        reviewTable.layer.cornerRadius = 14
        
        // 리뷰를 나타낼 테이블 뷰에 관한 설정을 해줍니다.
        let reviewItemNib = UINib(nibName: String(describing: ReviewItem.self), bundle: nil)
        reviewTable.register(reviewItemNib, forCellReuseIdentifier: String(describing: ReviewItem.self))
        let reviewContentNib = UINib(nibName: String(describing: ReviewContent.self), bundle: nil)
        reviewTable.register(reviewContentNib, forCellReuseIdentifier: String(describing: ReviewContent.self))
        reviewTable.dataSource = self
        reviewTable.delegate = self
        reviewTable.rowHeight = UITableView.automaticDimension
        reviewTable.estimatedRowHeight = 44
        
        // 리뷰 데이터를 불러옵니다.
        // loadReviewsWithMovieName()
        loadAllReviews()
    }
    
    // MARK: - 리뷰 데이터 받기
    // 현재 선택된 영화, 상영관에 대한 리뷰를 가져옵니다.
    func loadReviewsWithMovieName() {
        self.reviews = []
        guard let movieName: String = self.movieInfoLabel.text else { return }
        guard let theaterName: String = self.theaterInfoLabel.text else { return }
        print("선택된 영화(\(movieName))와 상영관 (\(theaterName))에 대한 리뷰를 가져옵니다.")
        db.collection("Review").whereField("영화", isEqualTo: movieName).whereField("상영관", isEqualTo: theaterName).addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("리뷰 데이터를 가져오는데 실패했습니다.")
                return
            }
            for document in documents {
                let data = document.data()
                guard let nickname = data["닉네임"] as? String else { continue }
                guard let password = data["비밀번호"] as? String else { continue }
                guard let reviewNum = data["리뷰번호"] as? String else { continue }
                guard let datetime = data["작성일"] as? String else { continue }
                guard let comment = data["코멘트"] as? String else { continue }
                guard let screenSize = data["스크린 크기"] as? Int else { continue }
                guard let screenQuality = data["스크린 선명도"] as? Int else { continue }
                guard let sound = data["사운드"] as? Int else { continue }
                guard let seat = data["좌석"] as? Int else { continue }
                guard let mood = data["분위기"] as? Int else { continue }
                let review = Review(nickname: nickname,
                                    password: password,
                                    reviewNum: reviewNum,
                                    datetime: datetime,
                                    comment: comment,
                                    screenSize: screenSize,
                                    screenQuality: screenQuality,
                                    sound: sound,
                                    seat: seat,
                                    mood: mood,
                                    isOpen: false)
                self.reviews.append(review)
                print("리뷰 데이터가 추가됐습니다.")
                print(review)
            }
            print("리뷰 데이터를 모두 가져왔습니다.")
            print("리뷰 테이블의 데이터를 반영합니다.")
            self.reviewTable.reloadData()
        }
    }
    
    // 현재 선택된 상영관에 대한 리뷰를 가져옵니다.
    func loadReviews() {
        self.reviews = []
        guard let theaterName: String = self.theaterInfoLabel.text else { return }
        print("선택된 상영관(\(theaterName))에 대한 리뷰를 가져옵니다.")
        db.collection("Review").whereField("상영관", isEqualTo: theaterName).addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("리뷰 데이터를 가져오는데 실패했습니다.")
                return
            }
            for document in documents {
                let data = document.data()
                guard let nickname = data["닉네임"] as? String else { continue }
                guard let password = data["비밀번호"] as? String else { continue }
                guard let reviewNum = data["리뷰번호"] as? String else { continue }
                guard let datetime = data["작성일"] as? String else { continue }
                guard let comment = data["코멘트"] as? String else { continue }
                guard let screenSize = data["스크린 크기"] as? Int else { continue }
                guard let screenQuality = data["스크린 선명도"] as? Int else { continue }
                guard let sound = data["사운드"] as? Int else { continue }
                guard let seat = data["좌석"] as? Int else { continue }
                guard let mood = data["분위기"] as? Int else { continue }
                let review = Review(nickname: nickname,
                                    password: password,
                                    reviewNum: reviewNum,
                                    datetime: datetime,
                                    comment: comment,
                                    screenSize: screenSize,
                                    screenQuality: screenQuality,
                                    sound: sound,
                                    seat: seat,
                                    mood: mood,
                                    isOpen: false)
                self.reviews.append(review)
                print("리뷰 데이터가 추가됐습니다.")
                print(review)
            }
            print("리뷰 데이터를 모두 가져왔습니다.")
            print("리뷰 테이블의 데이터를 반영합니다.")
            self.reviewTable.reloadData()
        }
    }
    
    // 전체 리뷰를 가져옵니다.
    func loadAllReviews() {
        self.reviews = []
        print("전체 리뷰를 가져옵니다.")
        db.collection("Review").addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("리뷰 데이터를 가져오는데 실패했습니다.")
                return
            }
            for document in documents {
                let data = document.data()
                guard let nickname = data["닉네임"] as? String else { continue }
                guard let password = data["비밀번호"] as? String else { continue }
                guard let reviewNum = data["리뷰번호"] as? String else { continue }
                guard let datetime = data["작성일"] as? String else { continue }
                guard let comment = data["코멘트"] as? String else { continue }
                guard let screenSize = data["스크린 크기"] as? Int else { continue }
                guard let screenQuality = data["스크린 선명도"] as? Int else { continue }
                guard let sound = data["사운드"] as? Int else { continue }
                guard let seat = data["좌석"] as? Int else { continue }
                guard let mood = data["분위기"] as? Int else { continue }
                let review = Review(nickname: nickname,
                                    password: password,
                                    reviewNum: reviewNum,
                                    datetime: datetime,
                                    comment: comment,
                                    screenSize: screenSize,
                                    screenQuality: screenQuality,
                                    sound: sound,
                                    seat: seat,
                                    mood: mood,
                                    isOpen: false)
                self.reviews.append(review)
                print("리뷰 데이터가 추가됐습니다.")
                print(review)
            }
            print("리뷰 데이터를 모두 가져왔습니다.")
            print("리뷰 테이블의 데이터를 반영합니다.")
            self.reviewTable?.reloadData()
        }
    }
    
    // MARK: - 세그먼트 컨트롤 이벤트 관리
    @IBAction func segChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loadReviewsWithMovieName()
        } else {
            loadReviews()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let dest = segue.destination as? ReviewWrtingVC else { return }
        dest.movieName = self.movieInfoLabel.text!
        dest.theaterName = self.theaterInfoLabel.text!
    }
    
    // 리뷰 작성 페이지에서 되돌아오면 작성한 리뷰를 업로드합니다.
    @IBAction func unwindToReview(_ segue: UIStoryboardSegue) {
        guard let source = segue.source as? ReviewWrtingVC else { return }
        source.upload()
    }
}

// MARK: - 테이블 뷰 데이터 관리
extension ReviewVC: UITableViewDataSource {
    // 섹션의 수를 리뷰의 수와 같게 만듭니다.
    func numberOfSections(in tableView: UITableView) -> Int {
        return reviews.count
    }
    
    // 셀의 수는 펼쳐진 리뷰의 수에 따라 달라집니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews[section].isOpen {
            return 2
        } else {
            return 1
        }
    }
    
    // 셀의 데이터를 채워넣습니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // 리뷰가 펼쳐지기 전에도 보이는 셀입니다.
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewItem.self), for: indexPath) as! ReviewItem
            cell.nicknameLabel.text = reviews[indexPath.section].nickname
            cell.datetimeLabel.text = reviews[indexPath.section].datetime
            cell.commentLabel.text = reviews[indexPath.section].comment
            
            cell.viewController = self
            cell.password = reviews[indexPath.section].password
            cell.reviewNum = reviews[indexPath.section].reviewNum
            return cell
        } else {
            // 리뷰가 펼쳐진 이후에 보이는 셀입니다.
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewContent.self), for: indexPath) as! ReviewContent
            cell.screenSizeLabel.text = String(reviews[indexPath.section].screenSize)
            cell.screenQualityLabel.text = String(reviews[indexPath.section].screenQuality)
            cell.soundLabel.text = String(reviews[indexPath.section].sound)
            cell.seatLabel.text = String(reviews[indexPath.section].seat)
            cell.moodLabel.text = String(reviews[indexPath.section].mood)
            return cell
        }
    }
}

// MARK: - 테이블 뷰 이벤트 관리
extension ReviewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ReviewItem else { return }
        guard let index = tableView.indexPath(for: cell) else { return }
        
        // 각 섹션의 첫 번째 셀을 선택했을 때만 처리합니다.
        if index.row == indexPath.row && index.row == 0 {
            if reviews[indexPath.section].isOpen {
                // 닫혀있던 리뷰를 펼칩니다.
                reviews[indexPath.section].isOpen = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            } else {
                // 펼쳐있던 리뷰를 닫습니다.
                reviews[indexPath.section].isOpen = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        }
    }
}
