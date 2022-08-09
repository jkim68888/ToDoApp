//
//  NoTasks.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/08.
//

import UIKit
import SnapKit

class NoTasksView: UIView {
    private let imgContainer = UIView()
    private let illustImg = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()
        setUI()
    }
    
    private func addViews() {
        self.addSubview(imgContainer)
        imgContainer.addSubview(illustImg)
    }

    private func setUI() {
        imgContainer.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        
        illustImg.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        illustImg.image = UIImage(named: "illust")
    }
}
