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
    @IBOutlet weak var filterSeg: UISegmentedControl!
    var theaterName: String = ""
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.reloadReview()
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
    
    // MARK: - 리뷰 삭제
    func deleteReview(reviewNum: String, password: String) {
        // 비밀번호를 입력 받는 알림창을 준비합니다.
        let alert = UIAlertController(
            title: "리뷰 삭제",
            message: "리뷰를 작성하실 때 입력했던 비밀번호를 입력해주세요.",
            preferredStyle: .alert)
        
        // 확인 버튼을 누른 경우입니다.
        let ok = UIAlertAction(title: "삭제", style: .destructive) { [weak alert, weak self](_) in
            guard let inputPassword = alert?.textFields?[0].text else {
                return
            }
            
            // 비밀번호를 입력하지 않은 경우입니다.
            if inputPassword == "" {
                let warn = UIAlertController(title: nil, message: "비밀번호를 입력해주세요.", preferredStyle: .alert)
                warn.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self?.present(warn, animated: true)
                return
            }
            
            // 비밀번호가 일치하지 않는 경우입니다.
            if inputPassword != password {
                let warn = UIAlertController(title: nil, message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
                warn.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self?.present(warn, animated: true)
                return
            }
            
            // 리뷰를 삭제합니다.
            self?.db.collection("Review").document(reviewNum).delete() { [weak self](err) in
                if err != nil {
                    print("리뷰를 삭제하지 못 했습니다. \(String(describing: err))")
                    return
                }
                print("리뷰를 성공적으로 삭제했습니다. reviewNum: \(reviewNum)")
                
                // 삭제를 완료했다는 알림을 띄웁니다.
                let info = UIAlertController(title: nil, message: "리뷰를 삭제했습니다.", preferredStyle: .alert)
                info.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self?.present(info, animated: true)
                
                // 리뷰 목록을 다시 불러옵니다.
                self?.reloadReview()
            }
        }
        
        // 취소 버튼을 누른 경우입니다.
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (cancel) in
            return
        }
        
        // 확인 버튼과 취소 버튼, 그리고 비밀번호 입력 필드를 알림창에 추가합니다.
        alert.addAction(ok)
        alert.addAction(cancel)
        alert.addTextField { textFiled in
            textFiled.placeholder = "비밀번호"
            textFiled.keyboardType = .numberPad
            textFiled.isSecureTextEntry = true
        }
        
        // 알림창을 띄웁니다.
        self.present(alert, animated: true)
    }
    
    // MARK: - 리뷰 목록 다시 불러오기
    func reloadReview() {
        if filterSeg.selectedSegmentIndex == 0 {
            loadReviewsWithMovieName()
        } else {
            loadReviews()
        }
    }
    
    // MARK: - 리뷰 신고
    func reportReview(reviewNum: String) {
        // 비밀번호를 입력 받는 알림창을 준비합니다.
        let alert = UIAlertController(
            title: "리뷰 신고",
            message: "해당 리뷰를 정말 신고하시겠어요?",
            preferredStyle: .alert)
        
        // 확인 버튼을 누른 경우입니다.
        let ok = UIAlertAction(title: "신고", style: .destructive) { [weak self](_) in
            // 리뷰의 누적신고횟수를 증가시킵니다.
            self?.db.collection("Review").document(reviewNum).getDocument(completion: { [weak self](document, err) in
                if let document = document, document.exists {
                    // 리뷰의 현재 누적신고횟수를 가져옵니다.
                    guard let accReportedCnt = document.data()?["누적신고횟수"] as? Int else {
                        print("해당 리뷰에 누적신고횟수가 누락되어 있습니다. reviewNum: \(reviewNum)")
                        self?.alertFailToReport()
                        return
                    }
                    // 리뷰의 누적신고횟수를 1만큼 증가시킵니다.
                    self?.db.collection("Review").document(reviewNum).updateData(["누적신고횟수": accReportedCnt + 1], completion: { [weak self](err) in
                        if err != nil {
                            print("리뷰를 삭제하지 못 했습니다. \(String(describing: err))")
                            self?.alertFailToReport()
                            return
                        }
                        print("리뷰를 성공적으로 삭제했습니다. reviewNum: \(reviewNum)")
                        
                        // 신고처리를 완료했다는 알림을 띄웁니다.
                        let info = UIAlertController(title: nil, message: "리뷰에 대한 신고처리가 완료됐습니다.", preferredStyle: .alert)
                        info.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self?.present(info, animated: true)
                    })
                } else {
                    print("해당 리뷰가 존재하지 않습니다. reviewNum: \(reviewNum)")
                    self?.alertFailToReport()
                }
            })
        }
        
        // 취소 버튼을 누른 경우입니다.
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (cancel) in
            return
        }
        
        // 확인 버튼과 취소 버튼, 그리고 비밀번호 입력 필드를 알림창에 추가합니다.
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // 알림창을 띄웁니다.
        self.present(alert, animated: true)
    }
    
    func alertFailToReport() {
        // 신고처리를 완료했다는 알림을 띄웁니다.
        let info = UIAlertController(title: nil, message: "기술적인 문제로 신고를 할 수 없어요.", preferredStyle: .alert)
        info.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(info, animated: true)
    }
    
    // MARK: - 리뷰 데이터 받기 (영화, 상영관 필터)
    // 현재 선택된 영화, 상영관에 대한 리뷰를 가져옵니다.
    func loadReviewsWithMovieName() {
        self.reviews = []
        guard let movieName: String = self.movieInfoLabel.text else { return }
        print("선택된 영화(\(movieName))와 상영관 (\(theaterName))에 대한 리뷰를 가져옵니다.")
        db.collection("Review").whereField("영화", isEqualTo: movieName).whereField("상영관", isEqualTo: theaterName).addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("리뷰 데이터를 가져오는데 실패했습니다.")
                return
            }
            print("서버로부터 데이터를 잘 가져왔습니다. (1)")
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
            }
            print("리뷰 데이터를 모두 가져왔습니다.")
            print("리뷰 테이블의 데이터를 반영합니다.")
            self.reviewTable.reloadData()
            if self.reviews.count == 0 {
                self.showToast(message: "리뷰가 없어요 :(")
            }
        }
    }
    
    // MARK: - 리뷰 데이터 받기 (상영관 필터)
    // 현재 선택된 상영관에 대한 리뷰를 가져옵니다.
    func loadReviews() {
        self.reviews = []
        print("선택된 상영관(\(theaterName))에 대한 리뷰를 가져옵니다.")
        db.collection("Review").whereField("상영관", isEqualTo: theaterName).addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("리뷰 데이터를 가져오는데 실패했습니다.")
                return
            }
            print("서버로부터 데이터를 잘 가져왔습니다. (2)")
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
            }
            print("리뷰 데이터를 모두 가져왔습니다.")
            print("리뷰 테이블의 데이터를 반영합니다.")
            self.reviewTable.reloadData()
            if self.reviews.count == 0 {
                self.showToast(message: "리뷰가 없어요 :(")
            }
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
        dest.theaterName = self.theaterName
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
            cell.reviewVC = self
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
