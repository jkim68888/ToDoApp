//
//  EditViewModel.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/17.
//

import Foundation
import RxSwift

class EditViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let tasksRepository = TasksRepository.shared
    
    func transform(input: Input) -> Output {
        let sectionSubject = ReplaySubject<[TasksSection]>.create(bufferSize: 1)
        
        tasksRepository.tasksSubject
            .map { tasks -> [TasksSection] in
                var section = TasksSection.init(header: "first Section",
                                                items: [],
                                                sectionId: UUID().uuidString)
                
                tasks.forEach { task in
                    section.items.append(task)
                }
                
                return [section]
            }
            .withUnretained(self)
            .subscribe(onNext: { (vm, sections) in
                sectionSubject.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        input.deleteTask
            .withUnretained(self)
            .flatMap{ (vm, task) -> Observable<[TasksData]> in
                return vm.tasksRepository.deleteTask(task: task)
            }
            .map { tasks -> [TasksSection] in
                var section = TasksSection.init(header: "first Section",
                                                items: [],
                                                sectionId: UUID().uuidString)
                tasks.forEach { task in
                    section.items.append(task)
                }
                
                return [section]
            }
            .subscribe( onNext: {sections in
                sectionSubject.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        input.deleteAll
            .withUnretained(self)
            .flatMap{ (vm, task) -> Observable<[TasksData]> in
                return vm.tasksRepository.deleteAll()
            }
            .map { tasks -> [TasksSection] in
                var section = TasksSection.init(header: "first Section",
                                                items: [],
                                                sectionId: UUID().uuidString)
                tasks.forEach { task in
                    section.items.append(task)
                }
                
                return [section]
            }
            .subscribe( onNext: {sections in
                sectionSubject.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        return Output(sectionsSubject: sectionSubject)
    }
}

extension EditViewModel {
    struct Input {
        var deleteTask: PublishSubject<TasksData>
        var deleteAll: PublishSubject<TasksData>
    }
    
    struct Output {
        var sectionsSubject: ReplaySubject<[TasksSection]>
    }
}
