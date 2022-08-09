//
//  BottomView.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/08.
//

import UIKit
import SnapKit

class BottomView: UIView {
    private let addBtn = UIButton()

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
        self.addSubview(addBtn)
    }

    private func setUI() {
        addBtn.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        
        addBtn.setImage(UIImage(named: "add"), for: .normal)
    }

}
