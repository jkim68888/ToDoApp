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
    private let tasksRepository = TasksRepository.sahred
    
    func transform(input: Input) -> Output {
        
        input.addTask
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: self.disposeBag)
        
        return Output()
    }
}

extension AddViewModel {
    struct Input {
        var addTask: PublishSubject<TasksData>
    }
    
    struct Output {
    }
}
