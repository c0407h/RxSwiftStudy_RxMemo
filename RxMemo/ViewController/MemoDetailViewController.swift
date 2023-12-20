//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import UIKit

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
        
    }
    
}
