//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel: NSObject {
    //앱을 구성하는 모든 씬은 네비게이션 컨트롤러에 임베드 되기 때문에 네비게이션 타이틀이 필요함
    
    //Driver형식으로 선언하여 네비게이션아이템에 쉽게 바인딩 가능
    let title: Driver<String>
    
    //두 속성의 형식을 보면 실제 형식이 아닌 프로토콜로 선언되어있음
    //이렇게 한 이유는 의존성을 쉽게 수정할 수 있기 때문
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    
    //뷰모델에서 공통적으로 사용하는 코드는 CommonViewModel class에서 구현
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
    
    
}

