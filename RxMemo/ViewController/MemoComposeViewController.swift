//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
        
    
    var viewModel: MemoComposeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
    
    
    func bindViewModel() {
        //네비게이션 타이틀 바인딩
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        
        //이렇게 바인딩하면 메모 쓰ㅜ기에서는 빈문자열 편집에서는 편집할 메모가 표시됨
        viewModel.initailText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
            
        cancelButton.rx.action = viewModel.cancelAction
        
        
        //세이브 버튼틀 탭했을 때 contentTextView에 있는 최신 텍스트가 방출되고
        //방출되는 텍스트가 saveAction에 있는 입력으로 바인딩됨
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
        
        
        //이렇게 notification메소드로 처리할 notification의 이름을 전달하면 해당 notification이 전달되는 시점마다
        //새로운 Next이벤트를 방출하는 Observable을 리턴해줌
        //그리고 next이벤트에는 notification 객체가 저장되어 있음
        //여기서 필요한것은 키보드의 높이인데 compactMap연산자를 활용해서 userinfo에 저장되어 있는 frame을 꺼낸 뒤
        //map연산자를 활용하여 키보드 높이를 방출
        //compactMap을 활용한ㄴ 이유는 옵셔널을 자동으로 언래핑하기 위해서임
        //이렇게 구현하면 Notification이 전달되는 시점마다 구독자에게 키보드 높이가 전달됨
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map{ $0.cgRectValue.height }
            
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0} //키보드가 사라지는 시점에는 textview아래에 추가한 여백을 제거하면 되기때문에 그냥 0을 방출
        
        //두 옵저버블을 Merge연산자로 병합
        //두 Notification이 전달되는 시점마다 하나의 옵저버블을 통해서 Next이벤트를 방출함
        //모든 구독자가 옵저버블을 구독하도록 share연산자추가
        
        let keyboardObservable =  Observable.merge(willShowObservable, willHideObservable)
            .share()
        //구독자를 추가하고 textview에 하단여백을 조절
        keyboardObservable
            .withUnretained(contentTextView)
            .subscribe(onNext: {tv, height in
                var inset = tv.contentInset
                inset.bottom = height
                tv.contentInset = inset
                
                //스크롤 인디케이터에도 하단여백 추가
                var scrollInset = tv.verticalScrollIndicatorInsets
                scrollInset.bottom = height
                tv.verticalScrollIndicatorInsets = scrollInset
            })
            .disposed(by: rx.disposeBag)
        
        
    }
    
}
