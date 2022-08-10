//
//  AddViewController.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let addViewContainer = UIView()
    private let topContainer = UIView()
    private let titleLabel = UILabel()
    private let closeBtn = UIButton()
    private let addTaskTextField = UITextField()
    private let priorityLabel = UILabel()
    private let priorityBtnContainer = UIView()
    private let highPriorityBtn = UIButton()
    private let normalPriorityBtn = UIButton()
    private let lowPriorityBtn = UIButton()
    private let saveBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setUI()
        bindRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateView()
    }
    
    private func addViews() {
        self.view.addSubview(addViewContainer)
        addViewContainer.addSubViews([topContainer, addTaskTextField, priorityLabel, priorityBtnContainer, saveBtn])
        topContainer.addSubViews([titleLabel, closeBtn])
        priorityBtnContainer.addSubViews([highPriorityBtn, normalPriorityBtn, lowPriorityBtn])
    }
    
    private func setUI() {
        addViewContainer.snp.makeConstraints{ (make) in
            make.height.equalTo(0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        topContainer.snp.makeConstraints{ (make) in
            make.height.equalTo(80)
            make.leading.trailing.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints{ (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        addTaskTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(topContainer.snp.bottom)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        priorityLabel.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(addTaskTextField.snp.bottom).offset(25)
        }
        
        priorityBtnContainer.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(priorityLabel.snp.bottom).offset(10)
            make.height.equalTo(55)
        }
        
        highPriorityBtn.snp.makeConstraints{ (make) in
            make.top.leading.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalToSuperview()
        }
        
        normalPriorityBtn.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(highPriorityBtn.snp.trailing).offset(10)
            make.width.equalTo(highPriorityBtn.snp.width)
            make.height.equalToSuperview()
        }
        
        lowPriorityBtn.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(normalPriorityBtn.snp.trailing).offset(10)
            make.width.equalTo(highPriorityBtn.snp.width)
            make.height.equalToSuperview()
        }
        
        saveBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(priorityBtnContainer.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(50)
        }
        
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        addViewContainer.backgroundColor = .white
        
        titleLabel.text = "할일 추가"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        
        addTaskTextField.backgroundColor = UIColor(hexString: "#EBEBEB")
        addTaskTextField.layer.cornerRadius = 5
        addTaskTextField.placeholder = "할일을 작성해주세요."
        
        priorityLabel.text = "중요도"
        priorityLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        highPriorityBtn.setTitle("높음", for: .normal)
        highPriorityBtn.setTitleColor(.black, for: .normal)
        highPriorityBtn.backgroundColor = UIColor(hexString: "#EBEBEB")
        highPriorityBtn.layer.cornerRadius = 5
        
        normalPriorityBtn.setTitle("보통", for: .normal)
        normalPriorityBtn.setTitleColor(.black, for: .normal)
        normalPriorityBtn.backgroundColor = UIColor(hexString: "#EBEBEB")
        normalPriorityBtn.layer.cornerRadius = 5
        
        lowPriorityBtn.setTitle("낮음", for: .normal)
        lowPriorityBtn.setTitleColor(.black, for: .normal)
        lowPriorityBtn.backgroundColor = UIColor(hexString: "#EBEBEB")
        lowPriorityBtn.layer.cornerRadius = 5
        
        saveBtn.setTitle("저장", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.backgroundColor = UIColor(hexString: "#A357D7")
        saveBtn.layer.cornerRadius = 5
        
        self.view.layoutIfNeeded()
    }
    
    private func animateView(completion: @escaping () -> Void = {}) {
        self.addViewContainer.snp.updateConstraints { (make) in
          make.height.equalTo(640)
        }
        UIView.animate(
        withDuration: 0.3,
        animations: {
            self.view.layoutIfNeeded()
        },
        completion: nil
        )
    }
    
    private func bindRx() {
        closeBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
        highPriorityBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.highPriorityBtn.backgroundColor = UIColor(hexString: "#D82525")
                self.normalPriorityBtn.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.lowPriorityBtn.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.highPriorityBtn.setTitleColor(.white, for: .normal)
                self.normalPriorityBtn.setTitleColor(.black, for: .normal)
                self.lowPriorityBtn.setTitleColor(.black, for: .normal)
            })
            .disposed(by: disposeBag)
        
        normalPriorityBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.highPriorityBtn.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.normalPriorityBtn.backgroundColor = UIColor(hexString: "#FFC700")
                self.lowPriorityBtn.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.highPriorityBtn.setTitleColor(.black, for: .normal)
                self.normalPriorityBtn.setTitleColor(.white, for: .normal)
                self.lowPriorityBtn.setTitleColor(.black, for: .normal)
            })
            .disposed(by: disposeBag)
        
        lowPriorityBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.highPriorityBtn.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.normalPriorityBtn.backgroundColor = UIColor(hexString: "#EBEBEB")
                self.lowPriorityBtn.backgroundColor = UIColor(hexString: "#249209")
                self.highPriorityBtn.setTitleColor(.black, for: .normal)
                self.normalPriorityBtn.setTitleColor(.black, for: .normal)
                self.lowPriorityBtn.setTitleColor(.white, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
