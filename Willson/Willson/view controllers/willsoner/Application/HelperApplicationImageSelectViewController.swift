//
//  HelperApplicationImageSelectViewController.swift
//  Willson
//
//  Created by JHKim on 13/10/2019.
//

import UIKit
import Kingfisher

class HelperApplicationImageSelectViewController: UIViewController {
    
    // MARK: - properties
    let cellIdentifier: String = "HelperImageCollectionViewCell"
    //    let imageNameArray: [String] = ["willson_01", "willson_02", "willson_03", "willson_04", "willson_05"]
    //    let typeLabelArray: [String] = ["재치있는 타입", "현실적인 타입", "진지한 타입", "들어주는 타입", "조언하는 타입"]
    //    let detailLabelArray: [String] = ["유머러스하고 친오빠, 형같은 이미지 이지만 센스있고 진중할 땐 진중한 타입", "연애 뿐 아니라 진로에서 현실적인 요소를 많이 고려하는 자기중심형 타입", "진지충", "오픈 유얼 이얼스", "개꼰대"]
    
    var image: Image?
    var imageData: [ImageData]?
    
    // 선택된 셀의 indexpath.item 값
    var selectedIndex: Int?
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        guard let introduction = introductionTextView.text else {
            print("introduction textview text 할당 오류")
            return
        }
        guard let index = selectedIndex else {
            print("selected Index 할당 오류")
            return
        }
        guard let imageIndex = imageData?[index].idx else {
            print("imageData?[index].idx 할당 오류")
            return
        }
        // UserDefaults - introduction, imageIndex
        UserDefaults.standard.set(introduction, forKey: "introduction")
        UserDefaults.standard.set(imageIndex, forKey: "imageIndex")
        guard let intro = UserDefaults.standard.value(forKey: "introduction") else {
            print("UserDefaults - introduction 할당 오류")
            return
        }
        guard let imgidx = UserDefaults.standard.value(forKey: "imageIndex") else {
            print("UserDefaults - imageIndex 할당 오류")
            return
        }
        print("UserDefaults - introduction: \(intro)")
        print("UserDefaults - imageIndex: \(imgidx)")
        
        let vc = UIStoryboard(name: "HelperApplication", bundle: nil).instantiateViewController(withIdentifier: "HelperApplicationAuthorizationViewController")
        self.navigationController?.show(vc, sender: nil)
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 윌스너 이미지 통신
        getImage()
        
        // keyboard nitificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        
        // collectionview delegate, datasource
        let imageCollectionViewLayout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        imageCollectionViewLayout.minimumLineSpacing = 0
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.decelerationRate = .fast
        
        // tap gesture
        let collectionTap = UITapGestureRecognizer(target: self, action: #selector(tappedCollectionCell(_:)))
        imageCollectionView.addGestureRecognizer(collectionTap)
        
        // textview delegate
        introductionTextView.delegate = self
        
        // textview count
        if introductionTextView.text != "내용을 입력해 주세요." {
            updateCharacterCount()
        } else { countLabel.text = "0" }
        
        // 처음에 버튼 비활성화
        nextButton.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 키보드 노티 분리
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    func checkAllInfoFilled() {
        if countLabel.text != "0" && selectedIndex != nil { nextButton.isEnabled = true }
        else { nextButton.isEnabled = false }
    }
    
    func getImage() {
        WillsonerRegisterServices.shared.getImage{ image in
            self.image = image
            self.imageData = self.image?.data
            
            print("=============")
            print("헬퍼 신청 - 이미지 통신 성공")
            
            self.imageCollectionView.reloadData()
        }
    }
}

extension HelperApplicationImageSelectViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setUpTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setUpTextView()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
        checkAllInfoFilled()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == introductionTextView) {
            return textView.text.count + (text.count - range.length) <= 300
        }
        return false
    }
    
    // 빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        for scrollView in view.subviews {
            for view1 in scrollView.subviews {
                for view2 in view1.subviews {
                    for textView in view2.subviews {
                        if textView is UITextView {
                            textView.resignFirstResponder()
                        }
                    }
                }
            }
        }
    }
    
    // 글자수 반영
    func updateCharacterCount() {
        let count = introductionTextView.text.count
        self.countLabel.text = "\(count)"
    }
    
    // 텍스트뷰 set up
    func setUpTextView() {
        if introductionTextView.text == "내용을 입력해 주세요." {
            introductionTextView.text = ""
            introductionTextView.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        } else if introductionTextView.text == "" {
            introductionTextView.text = "내용을 입력해 주세요."
            introductionTextView.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        //        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        //           let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        //        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            //            self.bottomConstraint.constant = +keyboardHeight
            self.scrollView.contentOffset = CGPoint(x: 0, y: 650)
        })
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            //            self.bottomConstraint.constant = 0
            self.scrollView.contentOffset = CGPoint(x: 0, y: 500)
        })
        
        self.view.layoutIfNeeded()
    }
}

// MARK: - UIScrollViewDelegate
extension HelperApplicationImageSelectViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == imageCollectionView {
            // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
            let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
            // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
            var offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            var roundedIndex = round(index)
            // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
            // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
            // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
            if scrollView.contentOffset.x > targetContentOffset.pointee.x {
                roundedIndex = floor(index)
            } else {
                roundedIndex = ceil(index)
            }
            // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
            targetContentOffset.pointee = offset

        
            /*
            // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
            let cellWidth: CGFloat = UIScreen.main.bounds.width - 80
            let insetX = (UIScreen.main.bounds.width - cellWidth) / 2.0
            
            // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
            // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
            let page: CGFloat = targetContentOffset.pointee.x / cellWidth
            let roundedPage = round(page)
            
            targetContentOffset.pointee = CGPoint(x: roundedPage * (cellWidth + insetX) - scrollView.contentInset.left, y: -scrollView.contentInset.top)
            */
            
        }
    }
}
// MARK: - UICollectionViewDelegate
extension HelperApplicationImageSelectViewController: UICollectionViewDelegate {
    
    @objc func tappedCollectionCell(_ sender: UITapGestureRecognizer) {
        guard let indexPath = imageCollectionView.indexPathForItem(at: sender.location(in: imageCollectionView)) else {
            print("collection cell index 할당 오류")
            return
        }
        selectedIndex = indexPath.item
        print("[tappedCollectionCell] selected cell index: \(selectedIndex ?? 0)")
        imageCollectionView.reloadData()
        checkAllInfoFilled()
    }
    
    /*
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     guard let cell = collectionView.cellForItem(at: indexPath) as? HelperImageCollectionViewCell else {
     print("collectionView.cellForItem(at: indexPath) 할당 오류")
     return
     }
     if cell.isSelected {
     cell.selectButton.setImage(UIImage(named: "ic_check_circle_navy"), for: .normal)
     } else {
     cell.selectButton.setImage(UIImage(named: "ic_check_circle_gray"), for: .normal)
     }
     print("selected cell index: \(indexPath.item)")
     }
     
     func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
     guard let cell = collectionView.cellForItem(at: indexPath) as? HelperImageCollectionViewCell else {
     print("collectionView.cellForItem(at: indexPath) 할당 오류")
     return
     }
     if cell.isSelected {
     cell.selectButton.setImage(UIImage(named: "ic_check_circle_navy"), for: .normal)
     } else {
     cell.selectButton.setImage(UIImage(named: "ic_check_circle_gray"), for: .normal)
     }
     print("deSelected cell index: \(indexPath.item)")
     }
     */
}

extension HelperApplicationImageSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = imageData?.count else {
            print("image data count 할당 오류")
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: HelperImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HelperImageCollectionViewCell else { return UICollectionViewCell() }
        
        // 이미지
        guard let urlString = imageData?[indexPath.item].pic else {
            print("imageData[indexpath.item].pic - 이미지 url 할당 오류")
            return UICollectionViewCell()
        }
        let url = URL(string: urlString)
        cell.imageView.kf.setImage(with: url)
        // 타이틀
        guard let title = imageData?[indexPath.item].name else {
            print("imageData[indexpath.item].name 할당 오류")
            return UICollectionViewCell()
        }
        cell.typeLabel.text = title
        // 디테일
        guard let detail = imageData?[indexPath.item].detail else {
            print("imageData[indexpath.item].detail 할당 오류")
            return UICollectionViewCell()
        }
        cell.detailLabel.text = detail
        
        // 선택
        switch indexPath.item {
        case selectedIndex:
            cell.checkButtonImageView.image = UIImage(named: "icCheckCircleBlue-1")
        default:
            cell.checkButtonImageView.image = UIImage(named: "icCheckCircleGray")
        }
        
        return cell
    }
}


extension HelperApplicationImageSelectViewController: UICollectionViewDelegateFlowLayout {
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 80, height: 467)
    }
}
