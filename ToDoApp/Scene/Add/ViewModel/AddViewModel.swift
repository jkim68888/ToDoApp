//
//  AddViewModel.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/09.
//

import Foundation
import RxSwift

class AddViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let tasksRepository = TasksRepository.shared
    
    func transform(input: Input) -> Output {
        let tasks = PublishSubject<[TasksData]>.init()
        let validationError = PublishSubject<String>.init()
        
        input.addTask
            .withUnretained(self)
            .flatMap{ (vm, data) -> Observable<[TasksData]> in
                if data.task == "" {
                    validationError.onNext("할일을 입력해주세요!")
                    return Observable.empty()
                } else if data.priority?.rawValue == TasksPriority.none.rawValue {
                    validationError.onNext("중요도를 선택해주세요!")
                    return Observable.empty()
                }
                return vm.tasksRepository.addTask(task: data)
            }
            .subscribe(onNext: { data in
                print(data)
                tasks.onNext(data)
            })
            .disposed(by: self.disposeBag)
        
        
        return Output(tasks : tasks,
                      validationError: validationError)
    }
}

extension AddViewModel {
    struct Input {
        var addTask: PublishSubject<TasksData>
    }
    
    struct Output {
        var tasks: PublishSubject<[TasksData]>
        var validationError: PublishSubject<String>
    }
}
