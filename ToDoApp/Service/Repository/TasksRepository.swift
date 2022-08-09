//
//  TasksRepository.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/09.
//

import Foundation
import RxSwift
import RxCocoa

protocol TasksRepositoryProtocol {
    var tasks: [TasksData] { get }
    
    func addTask(task: TasksData) -> Observable<[TasksData]>
    func deleteTask(task: TasksData) -> Observable<[TasksData]>
    func deleteAll() -> Observable<[TasksData]>
}

class TasksRepository: TasksRepositoryProtocol {
    // singletone
    // 여기서 한번만 생성시키고, 다른곳에서는 shared 로 호출하여 사용
    static let sahred = TasksRepository()
    
    var tasks: [TasksData] = []
    
    func addTask(task: TasksData) -> Observable<[TasksData]> {
        return Observable<[TasksData]>.create { observer -> Disposable in
            self.tasks.append(task)
            observer.onNext(self.tasks)
            
            return Disposables.create()
        }
    }
    
    func deleteTask(task: TasksData) -> Observable<[TasksData]> {
        return Observable<[TasksData]>.create { observer -> Disposable in
            self.tasks = self.tasks.filter { $0.id != task.id }
            observer.onNext(self.tasks)
            
            return Disposables.create()
        }
    }
    
    func deleteAll() -> Observable<[TasksData]> {
        return Observable<[TasksData]>.create { observer -> Disposable in
            self.tasks.removeAll()
            observer.onNext(self.tasks)
            
            return Disposables.create()
        }
    }
    
    
}
