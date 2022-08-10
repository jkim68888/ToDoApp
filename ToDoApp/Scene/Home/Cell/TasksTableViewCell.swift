//
//  TasksTableViewCell.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/10.
//

import UIKit
import SnapKit
import RxSwift

final class TasksTableViewCell: UITableViewCell {
    static let identifier = "TasksTableViewCell"
    
    var onData: AnyObserver<TasksData>
    var onDataBag = DisposeBag()
    var bag = DisposeBag()
    
    private var taskLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
      let cellData = PublishSubject<TasksData>()
      onData = cellData.asObserver()
      super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      bag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let cellData = PublishSubject<TasksData>()
        onData = cellData.asObserver()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bindRx()
        setUI()

        cellData
            .observeOn(MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: {(cell, data) in
                cell.taskLabel.text = data.task
            })
            .disposed(by: onDataBag)
    }
    
    private func setUI() {
        self.contentView.addSubViews([taskLabel])
        
        taskLabel.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindRx() {
        
    }

}
