//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import UIKit
import RxSwift
import RxCocoa

class MemoDetailViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    
    var viewModel: MemoDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        
        viewModel.contents
            .bind(to: contentTableView.rx.items) { tableView, row, value in
                switch row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        
        
        editButton.rx.action = viewModel.makeEditAction()
        
        shareButton.rx.tap
            .throttle(.microseconds(500), scheduler: MainScheduler.instance) //더블탭 방지
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                let memo = vc.viewModel.memo.content
                
                let activityVC = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                vc.present(activityVC, animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
          
        
        
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        //타이틀이 driver형태로 제공되기때문에 생성자로 전달할 수 없고 바인딩해야함
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx.disposeBag)
//        
//        backButton.rx.action = viewModel.popAction
//        //navigationItem.backBarButtonItem = backButton
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = backButton
        
        
        
    }
    
}
