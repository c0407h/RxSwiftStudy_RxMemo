//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    var viewModel: MemoListViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        //viewmodel과 view 바인딩
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        //메모목록을 테이블뷰에 바인딩
        //옵저버블과 테이블뷰를 바인딩하는 방식
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) {row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
        
        
        addButton.rx.action = viewModel.makeCreateAction()

    }

}
