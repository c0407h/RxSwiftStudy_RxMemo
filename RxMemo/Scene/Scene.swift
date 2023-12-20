//
//  Scene.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import UIKit

//앱에서 구현할 씬을 열거형으로 구현

enum Scene {
    //연관된 뷰모델을 연관값으로 저장
    case list(MemoListViewModel) //메모목록화면
    case detail(MemoDetailViewModel) //메모 보기 화면
    case compose(MemoComposeViewModel) // 메모 쓰기 화면
}

extension Scene {
    //스토리 보드에 있는 씬을 생성하고 연관값에 저장된 뷰모델을 바인딩해서 리턴하는 메소드
    
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let memoListViewModel):
            //메모 목록 씬을 생성한뒤 뷰모델을 바인딩해서 리턴
            //메모 목록 씬은 네비게이션 컨트롤러에 임베드 되어 있는 첫번째 씬이기 때문에
            //씬 자체를 만드는 것이아니라 네비게이션 컨트롤러를 만들어야함
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                listVC.bind(viewModel: memoListViewModel)
            }
            
            return nav
        case .detail(let memoDetailViewModel):
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                detailVC.bind(viewModel: memoDetailViewModel)
            }
            
            return detailVC
        case .compose(let memoComposeViewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                composeVC.bind(viewModel: memoComposeViewModel)
            }
            
            return nav
            
        }
    }
    
}

