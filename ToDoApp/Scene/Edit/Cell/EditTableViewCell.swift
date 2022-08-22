//
//  EditTableViewCell.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/17.
//

import UIKit
import RxSwift

class EditTableViewCell: UITableViewCell {
    static let identifier = "EditTableViewCell"
    
    var onData: AnyObserver<TasksData>
    var onDataBag = DisposeBag()
    var bag = DisposeBag()
    
    private var taskData: TasksData?
    
    private var checkbox = UIButton()
    private var taskLabel = UILabel()
    private var priorityCircle = UIImageView()
    private var deleteButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        let cellData = PublishSubject<TasksData>()
        onData = cellData.asObserver()
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        self.taskLabel.attributedText = self.taskLabel.text?.removeStrikeThrough()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let cellData = PublishSubject<TasksData>()
        onData = cellData.asObserver()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        bindRx()

        cellData
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: {(cell, taskData) in
                cell.taskData = taskData
                
                let priorityValue = taskData.priority
                let isChecked = taskData.isComplete
                
                cell.taskLabel.text = taskData.task
                
                if priorityValue == .high {
                    cell.priorityCircle.image = UIImage(named: "high")
                } else if priorityValue == .normal {
                    cell.priorityCircle.image = UIImage(named: "normal")
                } else if priorityValue == .low {
                    cell.priorityCircle.image = UIImage(named: "low")
                }
                
                if isChecked {
                    cell.checkbox.setImage(UIImage(named: "checked"), for: .normal)
                    cell.taskLabel.attributedText = cell.taskLabel.text?.strikeThrough()
                } else {
                    cell.checkbox.setImage(UIImage(named: "unchecked"), for: .normal)
                    cell.taskLabel.attributedText = cell.taskLabel.text?.removeStrikeThrough()
                }
            })
            .disposed(by: onDataBag)
    }
    
    private func setUI() {
        self.contentView.addSubViews([checkbox, taskLabel, priorityCircle, deleteButton])
        
        contentView.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        checkbox.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        
        taskLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkbox.snp.trailing).offset(5)
        }
        
        priorityCircle.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(deleteButton.snp.leading).offset(-20)
        }
        
        deleteButton.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(35)
        }
        
        priorityCircle.layer.cornerRadius = 100
        
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        
        self.selectionStyle = .none
    }
    
    private func bindRx() {
        deleteButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (cell, _) in
                guard let vc = cell.parentContainerViewController() as? EditViewController else { return }
                guard let taskData = cell.taskData else { return }
                vc.input.deleteTask.onNext(taskData)
            })
            .disposed(by: onDataBag)
    }

}
