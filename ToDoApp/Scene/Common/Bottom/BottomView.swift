//
//  BottomView.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BottomView: UIView {
    private let disposeBag = DisposeBag()
    
    private let addBtn = UIButton()
    var parentVC: HomeViewController?

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
        self.addSubview(addBtn)
    }

    private func setUI() {
        addBtn.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        
        addBtn.setImage(UIImage(named: "add"), for: .normal)
    }
    
    private func bindRx() {
        addBtn.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                let addView = AddViewController()
                addView.modalPresentationStyle = .overFullScreen
                self.parentVC?.present(addView, animated: false)
            })
            .disposed(by: disposeBag)
    }
}
