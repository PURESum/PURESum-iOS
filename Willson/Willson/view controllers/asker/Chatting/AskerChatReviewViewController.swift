//
//  AskerChatReviewViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/18.
//

import UIKit
import Kingfisher

class AskerChatReviewViewController: UIViewController {

    // MARK: - properties
    // chatRoom response model
    var chatRoomDataRow: Ing?
    
    // review complete response model
    var reviewComplete: ReviewComplete?
    
    // chat complete response model
    var chatComplete: ChatComplete?
    
    // 이미지
    var reviewImageData: ImageData?
    
    // gesture - star rate
    var ratingNumber: Float = 0.0
    
    // MARK: - IBOutlet
    // 닉네임
    @IBOutlet weak var helperNameLabel: UILabel!
    
    // 이미지 선택 버튼뷰 / 이미지뷰 / 레이블
    @IBOutlet weak var selectImageButtonView: CustomView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    // 별점 스택뷰 / 별 / 점수
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    @IBOutlet weak var starRateLabel: UILabel!
    
    // 한줄평 / 글자수
    @IBOutlet weak var oneLineTextField: UITextField!
    @IBOutlet weak var oneLineSizeLabel: UILabel!
    
    // 내용 / 글자수
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentSizeLabel: UILabel!
    
    // bottom constraint
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // 제출하기 버튼 뷰
    @IBOutlet weak var summitButtonView: UIView!
    @IBOutlet weak var 제출하기Button: UIButton!
    @IBOutlet weak var checkImgButton: UIButton!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 키보드
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nickname label
        guard let nickname = chatRoomDataRow?.willsoner?.asker.nickname else {
            print("viewDidLoad: willsoner nickname 할당 오류")
            return
        }
        helperNameLabel.text = nickname
        // 이미지 레이블
        imageLabel.text = "\(nickname)님과 어울리는 이미지를 선택해 주세요."
        
        // label initialization
        starRateLabel.text = "0.0"
        oneLineSizeLabel.text = "0"
        contentSizeLabel.text = "0"

        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        
        // 이미지 선택 버튼뷰
        let imageSelectGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedImageSelectButtonView(_:)))
        selectImageButtonView.addGestureRecognizer(imageSelectGesture)
        
        // add TapGestrue at StackView
        let starGesture = UITapGestureRecognizer(target: self, action: #selector(tappedStars(_:)))
        starStackView.addGestureRecognizer(starGesture)
        
        let starLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(draggingStars(_:)))
        starStackView.addGestureRecognizer(starLongGesture)
        
        // textfield delegate
        oneLineTextField.delegate = self
        oneLineTextField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
        
        // textview delegate
        contentTextView.delegate = self
        // textview count
        if contentTextView.text != "내용을 입력해 주세요." {
            updateCharacterCount()
        } else { contentSizeLabel.text = "0" }
        
        // 제출하기 버튼 뷰
        let summitGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedSummitButtonView(_:)))
        summitButtonView.addGestureRecognizer(summitGesture)
        summitButtonView.isUserInteractionEnabled = false
        제출하기Button.isEnabled = false
        제출하기Button.isUserInteractionEnabled = false
        checkImgButton.isEnabled = false
        checkImgButton.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 키보드 노티 분리
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Methods
    @objc func tappedImageSelectButtonView(_ gesture: UITapGestureRecognizer) {
        guard let vc: AskerChatSelectImageViewController = UIStoryboard(name: "AskerChat", bundle: nil).instantiateViewController(withIdentifier: "AskerChatSelectImageViewController") as? AskerChatSelectImageViewController else {
            print("tappedImageSelectButtonView: vc 할당 오류")
            return
        }
        // delegate !
        vc.askerChatReviewDelegate = self
        
        // modela presentation style
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func tappedStars(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let point = gesture.location(in: starStackView)
        
        changingStars(point.x)
    }
    
    
    @objc private func draggingStars(_ gesture: UILongPressGestureRecognizer) {
        self.view.endEditing(true)
        let point = gesture.location(in: starStackView)
        
        switch gesture.state {
        case .began, .changed: changingStars(point.x)
        default: break;
        }
    }
    
    private func changingStars(_ point: CGFloat) {
        ratingNumber = 0.0
        
        let viewWidth = starStackView.frame.size.width / 10
        let divideRating = Int(point/viewWidth/2)
        var oddRating = Int(point/viewWidth) % 2
        
        var starImage = UIImage(named: "icStarLineGray")
        for (index, subview) in starStackView.arrangedSubviews.enumerated() {
            if let imageSubview = subview as? UIImageView {
                if (index < divideRating) {
                    starImage = UIImage(named: "icStarBlueLarge")
                    ratingNumber += 1.0
                } else if (index >= divideRating && oddRating == 1) {
                    starImage = UIImage(named: "icStarHalfBlueLarge")
                    oddRating = 0
                    ratingNumber += 0.5
                } else {
                    starImage = UIImage(named: "icStarLineGrayLarge")
                }
                imageSubview.image = starImage
            }
        }
        starRateLabel.text = "\(Float(ratingNumber))"
        checkAllInfoFilled()
    }
    
    func checkAllInfoFilled() {
        if reviewImageData != nil && starRateLabel.text != "0.0" && oneLineSizeLabel.text != "0" && contentSizeLabel.text != "0" {
            제출하기Button.isEnabled = true
            checkImgButton.isEnabled = true
            summitButtonView.isUserInteractionEnabled = true
        } else {
            제출하기Button.isEnabled = false
            checkImgButton.isEnabled = false
            summitButtonView.isUserInteractionEnabled = false
        }
    }
    
    @objc func tappedSummitButtonView(_ gesture: UITapGestureRecognizer) {
        print("=======================")
        guard let matchIndex: Int = chatRoomDataRow?.idx else {
            print("tappedSummitButtonView: matchIndex 할당 오류")
            return
        }
        print("tappedSummitButtonView - matchIndex: \(matchIndex)")
        
        guard let willsonerIndex: Int = chatRoomDataRow?.willsoner?.idx else {
            print("tappedSummitButtonView: willsonerIndex 할당 오류")
            return
        }
        print("tappedSummitButtonView - willsonerIndex: \(willsonerIndex)")
        
        guard let title: String = oneLineTextField.text else {
            print("tappedSummitButtonView - oneLineTextField.text 할당 오류")
            return
        }
        print("tappedSummitButtonView - title: \(title)")
        
        guard let content: String = contentTextView.text else {
            print("tappedSummitButtonView - contentTextView.text 할당 오류")
            return
        }
        print("tappedSummitButtonView - content: \(content)")
        
        guard let ratingString: String = starRateLabel?.text else {
            print("tappedSummitButtonView - starTateLabel.text 할당 오류")
            return
        }
        guard let rating: Float = Float(ratingString) else {
            print("tappedSummitButtonView - rating (Float) 할당 오류")
            return
        }
        print("tappedSummitButtonView - rating: \(rating)")
        guard let imageIndex: Int = reviewImageData?.idx else {
            print("tappedSummiButtonView - imageIndex 할당 오류")
            return
        }
        print("tappedSummitButtonView - imageIndex: \(imageIndex)")
        
        ChatServices.shared.postReviewComplete(matchIndex: matchIndex, willsonerIndex: willsonerIndex, title: title, content: content, rating: rating, imageIndex: 2) { reviewComplete in
            self.reviewComplete = reviewComplete
            print("\(String(describing: self.reviewComplete))")
            print("==================")
            print("채팅 후기 작성 POST 통신 성공")
            
            ChatServices.shared.patchChatComplete(matchIndex: matchIndex) { chatComplete in
                self.chatComplete = chatComplete
                print("\(String(describing: self.chatComplete))")
                print("=====================")
                print("질문자 대화 종료 성공 ! ")
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        self.view.frame.origin.y = -keyboardHeight
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

// MARK: - AskerChatReviewDelegate
extension AskerChatReviewViewController: AskerChatReviewDelegate {
    func didselectedImage(reviewImageData: ImageData) {
        print("AskerChatReviewDelegate: didselecteImage 호출 !")
        self.reviewImageData = reviewImageData
        if let urlString = self.reviewImageData?.pic {
            if let encoded  = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
                imageView.kf.setImage(with: url)
                guard let detail = self.reviewImageData?.detail else {
                    print("didselectedImage: detail 할당 오류")
                    return
                }
                imageLabel.text = detail
                imageLabel.numberOfLines = 0
                self.loadViewIfNeeded()
            }
        } else {
            imageView.image = UIImage(named: "imgBearGood")
            guard let nickname = chatRoomDataRow?.willsoner?.asker.nickname else {
                print("didselecteImage: nick 할당 오류")
                return
            }
            imageLabel.text = "\(nickname)님과 어울리는 이미지를 선택해 주세요."
            print("imageBearGood")
            self.loadViewIfNeeded()
        }
        checkAllInfoFilled()
    }
}


//MARK: - UITextFieldDelegate
extension AskerChatReviewViewController: UITextFieldDelegate {
    
    @objc func textFieldChange(_ textField: UITextField) {
        guard let count = oneLineTextField.text?.count else {
            print("updateTextFieldCount: count 할당 오류")
            return
        }
        self.oneLineSizeLabel.text = "\(count)"
        checkAllInfoFilled()
    }
}

// MARK: - UITextViewDelegate
extension AskerChatReviewViewController: UITextViewDelegate {
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
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(textView == contentTextView) {
            return textView.text.count + (text.count - range.length) <= 100
        }
        return false
    }
    
    // 빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // 글자수 반영
    func updateCharacterCount() {
        let count = contentTextView.text.count
        self.contentSizeLabel.text = "\(count)"
        checkAllInfoFilled()
    }
    
    // 텍스트뷰 set up
    func setUpTextView() {
        if contentTextView.text == "내용을 입력해 주세요." {
            contentTextView.text = ""
            contentTextView.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        } else if contentTextView.text == "" {
            contentTextView.text = "내용을 입력해 주세요."
            contentTextView.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        }
    }
}
