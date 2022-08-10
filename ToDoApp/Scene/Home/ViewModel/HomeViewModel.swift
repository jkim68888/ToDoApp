//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/10.
//

import Foundation
import RxSwift

class HomeViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let tasksRepository = TasksRepository.sahred
    
    func transform(input: Input) -> Output {
        let tasks = PublishSubject<[TasksSection]>.init()
        
        tasksRepository.tasksSubject
            .map { data -> [TasksSection] in
                var section = TasksSection.init(header: "first Section",
                                                items: [],
                                                sectionId: UUID().uuidString)
                data.forEach { task in
                    section.items.append(task)
                }
                
                return [section]
            }
            .withUnretained(self)
            .subscribe(onNext: { (vm, data) in
                tasks.onNext(data)
                print("HomeViewModel : ", data)
            })
            .disposed(by: disposeBag)
        
        
        return Output(tasks : tasks)
    }
}

extension HomeViewModel {
    struct Input {

    }
    
    struct Output {
        var tasks: PublishSubject<[TasksSection]>
    }
}
