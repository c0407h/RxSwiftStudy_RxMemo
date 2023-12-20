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
        
    }
    
}
