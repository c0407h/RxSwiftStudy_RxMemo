//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
    //메모리에 메모를 저장함
    
    
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "I am Ruel", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    //클래스 외부에서 이 배열에 접근할 필요가 없어서 private
    //배열은 Observable을 통해서 외부로 공개됨
    //Observable은 배열의 상태가 업데이트되면 새로운 next이벤트를 방출해야함
    //그냥 Observable형식으로 만들면 불가능하기 때문에 subject로 만들어야함
//    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel])
    
    
    @discardableResult
    func createMemo(content: String) -> RxSwift.Observable<Memo> {
        let memo = Memo(content: content)
//        list.insert(memo, at: 0)
        sectionModel.items.insert(memo, at: 0)
        
//        store.onNext(list)
        store.onNext([sectionModel])
        
        return  Observable.just(memo)
    }
    
    @discardableResult
    func memoList() -> RxSwift.Observable<[MemoSectionModel]> {
//    func memoList() -> RxSwift.Observable<[Memo]> {
        //클래스 외부에서는 항상 이메소드를 통해 subject에 접근
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
        let updated = Memo(original: memo, updateContent: content)
        
//        if let index = list.firstIndex(where: { $0 == memo }) {
//            list.remove(at: index)
//            list.insert(updated, at: index)
//        }
        if let index = sectionModel.items.firstIndex(where: {$0 == memo}) {
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
                
        }
            
        
//        store.onNext(list)
        store.onNext([sectionModel])
        
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> RxSwift.Observable<Memo> {
//        if let index = list.firstIndex(where: {$0 == memo}) {
//            list.remove(at: index)
//        }
        if let index = sectionModel.items.firstIndex(where: {$0 == memo}) {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
//        store.onNext(list)
        
        return Observable.just(memo)
    }
    
    
}
