//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoComposeViewModel: CommonViewModel {
    //compose scene에서 사용
    //compose scene은 새로운 메모를 추가할때, 편집할때 공통적으로 사용
    
    //compose scene에 표시할 메모를 저장하는 속성 선언
    //새로운 메모를 추가할때는 nil 편집할때는 편집할 메모 저장
    private let content: String?
    
    //    content를 view에 바인딩 할 수 있도록 Driver추가
    var initailText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    //compose Scene에서는 저장과 취소 두가지를 구현
    
    //Action을 저장하는 속성 추가
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    //이후 navgationbar에 저장버튼과 취소버튼을 추가할 것인데 위 두개의 액션과 바인딩할 것임
    
    
    init(title:String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        self.content = content
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction{
                action.execute(input)
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
        //ViewModel에서 저장코드와 취소코드를 직접구현해도 되지만 이처럼 파라메터로 받으면
        //ViewModel에서 직접 받으면 처리방식이 하나로 고정됨
        //이처럼 파라메터로 받으면 이전화면에서 처리방식을 동적으로 결정할 수 있다는 장점이 있음
    }
    
}
