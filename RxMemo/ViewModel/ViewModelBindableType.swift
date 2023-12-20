//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import UIKit

//ViewModel과 View를 바인딩해주는 프로토콜
protocol ViewModelBindableType {
    //ViewModel의 타입은 ViewController마다 달라지기 때문에 protocol을 제네릭 protocol로 선언해야한다
    
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        //viewcontroller에 추가된 viewmodel속성에 파라메터로 전달된 실제 viewmodel 을 저장하고
        //bind(viewmodel:)메소드를 호출하도록 구현
        
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        
        bindViewModel()
        //ViewController에서 bind(viewModel:)메소드를 직접 호출할 필요가 없기때문에 코드가 단순해짐
        
    }
}
