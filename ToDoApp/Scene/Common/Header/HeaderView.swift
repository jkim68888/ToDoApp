//
//  HeaderView.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

class HeaderView: UIView {
    private let disposeBag = DisposeBag()
    
    private let logo = UIImageView()
    let editBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setUI()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()
        setUI()
        bindRx()
    }
    
    private func addViews() {
        self.addSubViews([logo, editBtn])
    }

    private func setUI() {
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
    
    private func bindRx() {
        editBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (v, _) in
                guard let vc = v.viewContainingController() as? HomeViewController else { return }
                vc.navigationController?.pushViewController(EditViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
