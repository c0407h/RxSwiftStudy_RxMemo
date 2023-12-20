//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxSwift
import RxCocoa
import Action



class MemoDetailViewModel: CommonViewModel {
    let memo: Memo
    
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
       return f
    }()
    
    
    //첫번째셀에는 메모 표시 두번째 셀에는 날짜 표시
    //테이블뷰에 데이터 표시를 위해 Observable과 바인딩
    //테이블뷰에 표시할 데이터는 문자열 두개 따라서 문자열 배열로 방출
    //BehaviorSubject를 사용한 이유 -> 메모 보기화면에서 메모편집버튼을 누르고 메모 편집하고 다시 메모 보기 화면으로 돌아오면
    //편집된 내용이 반영되어야 하는데 이때 새로운 문자열 배열을 방출해야함
    //일반 Observable로 선언하면 이게불가능 하기때문에 BehaviorSubject로 선언
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinator, storage: MemoryStorage) {
        self.memo = memo
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    
    lazy var popAction = CocoaAction{ [unowned self] in
        return self.sceneCoordinator.close(animated: true)
            .asObservable()
            .map {_ in}
    }
    
    //ComposeViewMedel로 전달하는 action
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input)
                .map { [$0.content, self.formatter.string(from: $0.insertDate)] }
                .bind(onNext: { self.contents.onNext($0) })
                .disposed(by: self.rx.disposeBag)
            
            
            return Observable.empty()
        }
    }
    //보기 화면에있는 편집버튼과 바인딩할 액션버튼
    func makeEditAction() -> CocoaAction {
        
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator , storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                .asObservable()
                .map { _ in }
            
        
        }
    }
    
    
    //삭제 버튼과 바인딩할 액션
    func makeDeleteAction() -> CocoaAction {
        return Action { input in
            self.storage.delete(memo: self.memo)
            return self.sceneCoordinator.close(animated: true)
                .asObservable()
                .map {_ in }
        }
    }
}
