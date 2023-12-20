//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxSwift


protocol MemoStorageType {
    //@discardableResult -> 작업 결과가 필요없을 때 사용
    @discardableResult
    func createMemo(content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]>
//    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
