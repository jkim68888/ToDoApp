//
//  ViewController.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/08.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    let headerView = HeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setUI()
    }
    
    func addViews() {
        self.view.addSubViews([headerView])
    }

    func setUI() {
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        self.view.backgroundColor = .white
    }

}

