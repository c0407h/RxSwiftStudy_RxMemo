//
//  Memo.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import Foundation
import RxDataSources // tableview 와 colletionview에 바인딩 할 수있는 datasource를 제공
import CoreData
import RxCoreData

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

extension Memo: Persistable {
    static var entityName: String {
        return "Memo"
    }
    
    static var primaryAttributeName: String {
        return "identity"
    }
    
    init(entity: NSManagedObject) {
        content = entity.value(forKey: "content") as! String
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    //현재 인스턴스에 저장되어 있는 데이터로 NSManagedObject 업데이트 메소드 구현
    func update(_ entity: NSManagedObject) {
        entity.setValue(content, forKey: "content")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        //RxCoreData는 context를 자동으로 저장해주기 때문에 보통은 save를 직접 호출하지 않음
        //그러나 구현하고 있는 메소드는 RxCoreData를 사용하는 것이 아니라 그냥 코어데이터가 기본으로 제공하는 코드를 사용중임
        //그래서 직접 save메소드를 호출해야함 -> 하지 않으면 경우에 따라 업데이트 한 내용이 사라질 수도 있음
        //coreData를 rx방식으로 구현할 때는 항상 이부분을 조심해야함
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error)
        }
        
    }
    
    
    
}
