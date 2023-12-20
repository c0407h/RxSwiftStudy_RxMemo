//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxDataSources

typealias MemoSectionModel = AnimatableSectionModel<Int, Memo>

class MemoListViewModel: CommonViewModel {
    //ViewModel에는 크게 두가지가 추가됨
    //의존성을 주입하는 이니셜라이저와 바인딩에 사용되는 속성과 메소드가 추가됨
    //ViewModel은 화면전환과 메모 저장을 모두 처리하는데 SceneCoordinator와 MemoStorage를 활용
    //viewmodel을 생성하는 시점에 이니셜라이저를 통해 의존성을 주입해야함
    
    //메모 목록화면에서 필요한 것은 메모 목록임
    //따라서 테이블뷰와 바인딩 할 수 있는 속성을 추가해야함
    
//    var memoList: Observable<[Memo]> {
//        return storage.memoList()
//        //저장소에 구현되어잇는 메모리스트 호출 후 메소드가 리턴하는 옵저버블을 그대로 리턴
//    }
    
    //Observable이 메모 배열을 방출하는데 이부분을 RxDataSources가 요구하는 방식으로 바꾸자
    //섹션 모델을 생성한 다음 섹션데이터와 로우 데이터를 저장하고 옵저버블이 섹션 모델배열을 방출하도록 수정해야함
    //RxDataSources가 제공하는 기본 섹션 모델중에서 애니메이터블 섹션 모델을 사용하자
    
//    var memoList: Observable<[MemoListViewModel]> {
    var memoList: Observable<[MemoSectionModel]> {
        return storage.memoList()
//        return storage.memoList()
    }
    
    //테이블뷰 바인딩에 사용할 데이터 소스를 속성으로 선언
    let dataSource: RxTableViewSectionedAnimatedDataSource<MemoSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<MemoSectionModel>(configureCell: { (dataSource, tableView, indexPath, memo) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = memo.content
            return cell
        })
        ds.canEditRowAtIndexPath = { _, _ in return true}
        return ds
    }()
    
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            
            return self.storage.createMemo(content: "")
                .flatMap { memo -> Observable<Void> in
                //새로운 viewmodel 생성
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo) , cancelAction: self.performCancel(memo: memo))
                    
                    //컴포즈 씬 생성 연관값으로 viewmodel 전달
                    let composeScene = Scene.compose(composeViewModel)
                    
                    //씬코디에니터에서 트랜지션 호출 씬을 모달
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                        .asObservable()
                        .map { _ in }
                }
        }
    }
    
    //Action은 두개의 파라메터를 받는데 왼쪽이 입력 오른쪽이 출력
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input).map {_ in }
        }
    }
    
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map { _ in}
        }
    }
    
    lazy var detailAction: Action<Memo, Void> = {
        //클로저 내부에서 self에 접근해야하기때문에 lazy로 선언
        return Action { memo in
            //viewmodel을 만들고 scene을 만들어
            //scenecoordinator의 trasition을 호출하여 실제로 화면 전환
            
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator as! SceneCoordinator, storage: self.storage as! MemoryStorage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
                .asObservable()
                .map {_ in }
            
            
            
        }
    }()
    
    lazy var popAction = CocoaAction{ [unowned self] in
        return self.sceneCoordinator.close(animated: true)
            .asObservable()
            .map {_ in}
    }
    
    lazy var deleteAction: Action<Memo, Void> = {
        return Action { memo in
            return self.storage.delete(memo: memo)
                .map{ _ in }
        }
    }()
    
}
