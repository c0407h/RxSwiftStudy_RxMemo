//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    
    //SceneCoordinator는 화면전환을 처리하기때문에 window 인스턴스와 현재화면에 표시되어있는 씬을 가지고 있어야함
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> RxSwift.Completable {
        //화면전환결과를 방출할 subject선언
        let subject = PublishSubject<Never>() // 화면전환의 성공과 실패만 방출함 따라서 element의 타입을 Naver로 선언 next이벤트는 방출할 필요가 없음
        
        //씬 생성하여 상수에 저장
        let target = scene.instantiate()
        
        //transitionStyle에 따라서 실제 전환을 처리
        switch style {
        case .root:
            currentVC = target
            window.rootViewController = target
            
            subject.onCompleted()
        case .push:
            //push는 네비게이션 컨트롤러에 임베드 되어있어야 의미가 있음
            //네비게이션 컨트롤러에 임베드 되어 있지 않다면 에러를 방출하고 종료시키자
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            //네비게이션컨트롤러에 임베드 되어 있다면 씬을 푸쉬하고 컴플리티드 이벤트 전달
            nav.pushViewController(target, animated: animated)
            currentVC = target
            subject.onCompleted()
        case .modal:
            //씬을 프레젠트
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            
            currentVC = target
        }
        
        return subject.asCompletable()
    }
    
    
    @discardableResult
    func close(animated: Bool) -> RxSwift.Completable {
        
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
            }
            
            //현재씬이 네비게이션 스택에 푸쉬되어 있다면 씬을 팝하자
            //팝을 못하면 에러이벤트를 전달하고 종료
            else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            }
            
            else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
            
        }
    }
    
    
}

