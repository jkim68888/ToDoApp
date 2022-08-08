//
//  HeaderView.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/08.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    private let logo = UIImageView()
    private let editBtn = UIButton()

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
    
    func addViews() {
        self.addSubViews([logo, editBtn])
    }

    func setUI() {
        logo.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        editBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        logo.image = UIImage(named: "logo")
        
        editBtn.setTitle("편집", for: .normal)
        editBtn.setTitleColor(.blue, for: .normal)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        
        // editBtn 숨김
        editBtn.isHidden = true
    }
}
