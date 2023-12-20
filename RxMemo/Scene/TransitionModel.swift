//
//  TransitionModel.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation

//화면 전환과 관련된 열거형

enum TransitionStyle {
    case root // 첫번째 화면 표시할때 사용
    case push // 새로운 화면을 네비게이션 스택에 푸시할때 사용
    case modal // 새로운 화면을 모달형태로 표시할 떄 사용
}


//화면전환에서 문제가 발생했을때 사용할 에러형식 선언
enum TransitionError: Error {
    case navigationControllerMissing //네비게이션컨트롤러가 없을때
    case cannotPop // 네비게이션 스택에 추가되어 있는 뷰컨트롤러를 팝할 수 없을때
    case unknown
}

