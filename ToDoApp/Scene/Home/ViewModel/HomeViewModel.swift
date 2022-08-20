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
    private let tasksRepository = TasksRepository.shared
    
    func transform(input: Input) -> Output {
        let sectionsSubject = ReplaySubject<[TasksSection]>.create(bufferSize: 1)
        
        input.initializeTasks
            .withUnretained(self)
            .flatMap{ (vm, task) -> Observable<[TasksData]> in
                return vm.tasksRepository.getRealmTasks()
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
            .withUnretained(self)
            .subscribe(onNext:  { (vm, sections) in
                sectionsSubject.onNext(sections)
                print("HomeViewModel : ", sections)
            })
            .disposed(by: disposeBag)
        
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
                sectionsSubject.onNext(sections)
                print("HomeViewModel : ", sections)
            })
            .disposed(by: disposeBag)
        
        input.updateTask
            .withUnretained(self)
            .flatMap { (vm, task) -> Observable<[TasksData]> in
                var updatedTask = task
                updatedTask.isComplete = !updatedTask.isComplete
                return vm.tasksRepository.updateTask(task: updatedTask)
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
            .subscribe(onNext: { sections in
                print(sections)
                sectionsSubject.onNext(sections)
            })
            .disposed(by: disposeBag)
        
        
        return Output(sectionsSubject : sectionsSubject)
    }
}

extension HomeViewModel {
    struct Input {
        var updateTask: PublishSubject<TasksData>
        var initializeTasks: ReplaySubject<ViewModelExecution>
    }
    
    struct Output {
        var sectionsSubject: ReplaySubject<[TasksSection]>
    }
}
