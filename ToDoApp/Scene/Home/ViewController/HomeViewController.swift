//
//  ViewController.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/08.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private let headerView = HeaderView()
    private let noTasksView = NoTasksView()
    private let bottomView = BottomView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setUI()
        bottomView.parentVC = self
    }
    
    private func addViews() {
        self.view.addSubViews([headerView, noTasksView, bottomView])
    }

    private func setUI() {
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        noTasksView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
        bottomView.snp.makeConstraints{ (make) in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(noTasksView.snp.bottom)
        }
        
        self.view.backgroundColor = .white
    }

}

