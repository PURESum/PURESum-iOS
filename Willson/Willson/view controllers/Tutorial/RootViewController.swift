//
//  RootViewController.swift
//  Willson
//
//  Created by JHKim on 2020/03/24.
//

import UIKit

class RootViewController: UIPageViewController {
    
    // MARK: - properties
    //뷰 컨트롤러 객체들을 담아 놓는 프로퍼티
    var viewControllerList : [UIViewController] = {
        let sb = UIStoryboard(name: "Tutorial", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: "TutorialConcernViewController")
        let vc2 = sb.instantiateViewController(withIdentifier: "TutorialWillsonerViewController")
        let vc3 = sb.instantiateViewController(withIdentifier: "TutorialChatViewController")
        let vc4 = sb.instantiateViewController(withIdentifier: "TutorialCompleteViewController")
        return [vc1, vc2, vc3, vc4]
    }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var skipBarButtonItem: UIBarButtonItem!
    
    // MARK: - IBAction
    @IBAction func tappedSkip(_ sender: Any) {
        // 튜토리얼은 앱 실행 처음에만 보여주도록!
        UserDefaults.standard.set(true, forKey: "tutorialRead")
        
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate, dataSource
        self.delegate = self
        self.dataSource = self
        
        // 페이지뷰컨트롤러의 Root로 viewControllerList의 첫번째 뷰 컨트롤러(FirstVC)를 지정
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        // 튜토리얼은 최초 한번만
        if let tutorialRead = UserDefaults.standard.value(forKey: "tutorialRead") {
            print("=======================")
            print("tutorialRead: \(tutorialRead), 로그인 화면으로 이동합니다.")
            let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.numberOfPages = viewControllerList.count
        pageControl.currentPage = 0
    }
}

extension RootViewController: UIPageViewControllerDelegate {
    
}

extension RootViewController: UIPageViewControllerDataSource {
    // before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //현재 뷰에 띄워져있는 뷰 컨트롤러의 인덱스값을 옵셔널 바인딩을 이용해서 가져옵니다
        //index(of:viewController) 에 있는 viewController는 이 딜리게이트 메소드의 두번쨰 내부 매개변수로서, 현재 뷰에 보여지고 있는 뷰컨트롤러 객체를 참조합니다
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {
            return nil
        }
        // page controll
        pageControl.currentPage = vcIndex
        print("BeforeVCIndex: \(vcIndex)")
        
        //현재 인덱스값 - 1 = 이전 인덱스값
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            //previousIndex < 0
            //이전 뷰컨트롤러의 인덱스가 0보다 작아질경우(첫번째 뷰가 선택된 상황에서 왼쪽으로 스와이프(더 이전으로 가려고 할경우, 즉 인덱스값이 0보다 작을떄)
            //마지막 뷰 컨트롤러가 나타나게 해줍니다
            
            //return viewControllerList.last
            return nil
        }
        guard viewControllerList.count > previousIndex else {
            //previousIndex >= viewControllerList.count
            return nil
        }

        //이전 인덱스값을 가진 뷰컨트롤러 객체 반환
        return viewControllerList[previousIndex]
    }
    
    // after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //현재 뷰에 띄워져있는 뷰 컨트롤러의 인덱스값을 옵셔널 바인딩을 이용해서 가져옵니다
        //index(of:viewController) 에 있는 viewController는 이 딜리게이트 메소드의 두번쨰 내부 매개변수로서, 현재 뷰에 보여지고 있는 뷰컨트롤러 객체를 참조합니다
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {
            return nil
        }
        // page controll
        pageControl.currentPage = vcIndex
        print("AfterVCIndex: \(vcIndex)")
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {
            
            //nextIndex == viewControllerList.count
            //마지막 뷰 컨트롤러에서 오른쪽으로 스와이프(다음 뷰 컨트롤러)로 이동하려고 할경우, 첫번쨰 뷰 컨트롤러로 이동시켜줍니다
            //return viewControllerList.first
            return nil
        }
        
        guard viewControllerList.count > nextIndex else {
            //viewControllerList.count <= nextIndex
            return nil
        }
        
        //다음 인덱스값을 가진 뷰 컨트롤러 객체 반환
        return viewControllerList[nextIndex]
    }
}
