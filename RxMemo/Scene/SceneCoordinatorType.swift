//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxSwift

//씬 코디네이터가 공통적으로 구현해야할 멤버 선언
protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    // 이 메소드는 새로운 씬을 표시함 파라메터로 대상 신과 트랜지션스타일, 애니메이션 플래그를 전달함
    
    @discardableResult
    func close(animated: Bool) -> Completable
    //이 메소드느 현재 씬을 닫고 이전 씬으로 돌아감
    
    //리턴형이 모두 Completable로 되어있는데 여기에 구독자를 추가하고 화면전환이 완료되었을때의 원하는 작업을 구현할 수 있음
    
    
    
}

