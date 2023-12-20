//
//  Memo.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxDataSources // tableview 와 colletionview에 바인딩 할 수있는 datasource를 제공

struct Memo: Equatable, IdentifiableType {
    var content: String //메모 컨텐츠
    var insertDate: Date //메모 생성날짜
    var identity: String //메모를 구분할때 사용
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    //업데이트 된 내용으로 새로운 메모 인스턴스 만들때 사용
    init(original: Memo, updateContent: String) {
        self = original
        self.content = updateContent
    }
}
