//
//  CoreDataStorage.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/21/23.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import RxCoreData

class CoreDataStorage: MemoStorageType {
    //모델이름을 저장할 속성 추가
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        //모델 이름이 리터럴로 입력되어있음 "RxMemo" -> 다른 모델도 사용할 수 있도록 수정하자
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    //main context속성 추가
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //CRUD구현
    //코어데이터 역시 옵저버블을 활용하는 패턴으로 구현해야함
    //직접 구현할 수 있지만 이미 검증 되어잇는 rxcoredata활용
    @discardableResult
    func createMemo(content: String) -> RxSwift.Observable<Memo> {
        //새로운 메모 인스턴스 생성
        let memo = Memo(content: content)
        
        do {
            //새로운 메모 추가스 update 메소드 사용
            //update메소드는 upsert방식으로 동작함
            // -> 파라메터로 전달한 메모가 이미 저장되어 있다면 업데이트 없다면 새로 추가
            _ = try mainContext.rx.update(memo)
            //메모가 정상적으로 추가되었다면 옵저버블을 통해서 방출
            return Observable.just(memo)
        } catch {
            //문제가 있다면 전달된 에러를 그대로 방출
            return Observable.error(error)
        }
        
    }
    
    @discardableResult
    func memoList() -> RxSwift.Observable<[MemoSectionModel]> {
        //메모 목록 리턴
        //그냥 coredata로 구현한다면 fetch request를 만들어야함
        //rxcordData에서는 하나의 메소드로 끝남
        
        
        //첫번째 파라메터에는 Memo타입을 전달 -> 코어데이터에 저장된 데이터가 메모 인스턴스로 리턴됨
        //두번째 파라메터에는 predicate를 전달하는데 여기서는 그냥 생략.
        //세번째 파라메터에는 날자를 내림차순으로 정렬하는 sortDescriptors전달
//        return mainContext.rx.entities(Memo.self, predicate: <#T##NSPredicate?#>, sortDescriptors: <#T##[NSSortDescriptor]?#>)
        
        //여기서사용한 entities 메소드는 옵저버블을 리턴하고 옵저버블이 방출하는 요소의 형식은 첫번째 파라메터로 전달한 형식의 배열임
        //메모리스트 메소드가 리턴하는 옵저버블은 MemoSectionModel 배열을 방출해야함 따라서 Map연산자를 활용하여 MemoSectionModel배열로 변환
        return mainContext.rx.entities(Memo.self,sortDescriptors: [NSSortDescriptor(key: "insertDate", ascending: false)])
            .map { result in [MemoSectionModel(model: 0, items: result)] }
        
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
        //메모 인스턴스와 변경된 내용이 파라메터로 전달
        //메모가 구조체로 선언되어있고 파라메터는 기본적으로 상수이기 때문에
        //memo.content = content // -> 이런 형태의 코드는 사용할 수 없음
        
        //여기서는 변경된 내용을 기반으로 새로운 인스턴스를 생성
        let updated = Memo(original: memo, updateContent: content)
        
        //나머지는 create메소드와 동일
        do {
            _ = try mainContext.rx.update(updated)
            return Observable.just(updated)
        } catch {
            return Observable.error(error)
        }
        
    }
    
    @discardableResult
    func delete(memo: Memo) -> RxSwift.Observable<Memo> {
        do {
            //delete 메소드만 호출하면됨
            try mainContext.rx.delete(memo)
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
        
        
        
    }
    
    
}
