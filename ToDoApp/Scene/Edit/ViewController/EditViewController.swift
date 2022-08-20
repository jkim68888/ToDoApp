//
//  EditViewController.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class EditViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    let viewModel = EditViewModel()
    lazy var input = EditViewModel.Input(deleteTask: .init(), deleteAll: .init())
    lazy var output = viewModel.transform(input: input)
    
    private let headerView = HeaderView()
    private let editTableView = UITableView()
    private var deleteAllButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setUI()
        bindRx()
    }
    
    private func addViews() {
        self.view.addSubViews([headerView, editTableView, deleteAllButton])
        
        self.editTableView.register(EditTableViewCell.self, forCellReuseIdentifier: EditTableViewCell.identifier)
    }
    
    private func setUI() {
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        editTableView.snp.makeConstraints{ (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
        deleteAllButton.snp.makeConstraints{ (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        self.view.backgroundColor = .white
        
        self.headerView.editBtn.isHidden = false
        self.headerView.editBtn.setTitle("완료", for: .normal)
        
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.setTitleColor(.red, for: .normal)
        deleteAllButton.backgroundColor = UIColor(hexString: "#FFFFFF")
        deleteAllButton.layer.cornerRadius = 5
        deleteAllButton.layer.borderWidth = 1
        deleteAllButton.layer.borderColor = UIColor.red.cgColor
    }
    
    private func bindRx() {
        output.sectionsSubject
            .bind(to: editTableView.rx.items(dataSource: editDatasources))
            .disposed(by: disposeBag)
    }
}

typealias EditDatasources = RxTableViewSectionedAnimatedDataSource<TasksSection>

extension EditViewController: UITableViewDelegate {
    private var editDatasources: EditDatasources {
          let datasource = EditDatasources.init(decideViewTransition: { _, tableView, changeset in
              return .reload
            },configureCell: {[weak self] _, tableView, indexPath, item -> UITableViewCell in
                guard let self = self else { return UITableViewCell()}
                let cell: EditTableViewCell = tableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier, for: indexPath) as! EditTableViewCell
                cell.onData.onNext(item)
                return cell
            })
          return datasource
        }

}
