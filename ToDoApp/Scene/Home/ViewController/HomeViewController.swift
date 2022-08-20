//
//  ViewController.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/08.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    let viewModel = HomeViewModel()
    lazy var input = HomeViewModel.Input(updateTask: .init())
    lazy var output = viewModel.transform(input: input)
    
    private let headerView = HeaderView()
    private let noTasksView = NoTasksView()
    private let bottomView = BottomView()
    
    private let tasksTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        addViews()
        setUI()
        bindRx()
        bottomView.parentVC = self
    }
    
    private func addViews() {
        self.view.addSubViews([headerView, noTasksView, tasksTableView, bottomView])
        
        self.tasksTableView.register(TasksTableViewCell.self, forCellReuseIdentifier: TasksTableViewCell.identifier)
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
        
        tasksTableView.snp.makeConstraints{ (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
        self.view.backgroundColor = .white
        tasksTableView.isHidden = true
    }
    
    private func bindRx() {
        output.sectionsSubject
            .withUnretained(self)
            .map{ (vc, sections) in
                vc.tasksTableView.isHidden = sections.first?.items.count == 0
                vc.noTasksView.isHidden = sections.first?.items.count != 0
                vc.headerView.editBtn.isHidden = sections.first?.items.count == 0
                
                return sections
            }
            .bind(to: tasksTableView.rx.items(dataSource: tasksDatasources))
            .disposed(by: disposeBag)
    }
}

typealias TasksDatasources = RxTableViewSectionedAnimatedDataSource<TasksSection>

extension HomeViewController: UITableViewDelegate {
    private var tasksDatasources: TasksDatasources {
          let datasource = TasksDatasources.init(decideViewTransition: { _, tableView, changeset in
              return .reload
            },configureCell: {[weak self] _, tableView, indexPath, item -> UITableViewCell in
                guard let self = self else { return UITableViewCell()}
                let cell: TasksTableViewCell = tableView.dequeueReusableCell(withIdentifier: TasksTableViewCell.identifier, for: indexPath) as! TasksTableViewCell
                cell.onData.onNext(item)
                return cell
            })
          return datasource
        }

}

