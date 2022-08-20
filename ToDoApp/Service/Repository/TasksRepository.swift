//
//  TasksRepository.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/09.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol TasksRepositoryProtocol {
    var tasks: [TasksData] { get }
    
    var tasksSubject: ReplaySubject<[TasksData]> { get }
    
    func getRealmTasks() -> Observable<[TasksData]>
    func addTask(task: TasksData) -> Observable<[TasksData]>
    func updateTask(task: TasksData) -> Observable<[TasksData]>
    func deleteTask(task: TasksData) -> Observable<[TasksData]>
    func deleteAll() -> Observable<[TasksData]>
}

class TasksRepository: TasksRepositoryProtocol {
    // Realm 가져오기
    let realm = try! Realm()
    
    let tasksSubject = ReplaySubject<[TasksData]>.create(bufferSize: 1)
    
    // singletone
    // 여기서 한번만 생성시키고, 다른곳에서는 shared 로 호출하여 사용
    static let shared = TasksRepository()
    
    var tasks: [TasksData] = []
    
    func getRealmTasks() -> Observable<[TasksData]> {
        return Observable<[TasksData]>.create{ observer -> Disposable in
            let realmSavedTasks = self.realm.objects(TasksData.self)
            observer.onNext(realmSavedTasks.filter{ _ in true })
            
            self.tasks = realmSavedTasks.filter{ _ in true }
            
            return Disposables.create()
        }
    }
    
    func addTask(task: TasksData) -> Observable<[TasksData]> {
        return Observable<[TasksData]>.create { observer -> Disposable in
            self.tasks.append(task)
            self.tasksSubject.onNext(self.tasks)
            observer.onNext(self.tasks)
            
            try! self.realm.write {
                self.realm.add(task)
                
                print("렐름 프리오리티: ", task.priority)
            }
            
            return Disposables.create()
        }
    }
    
    func updateTask(task: TasksData) -> Observable<[TasksData]> {
        return Observable<[TasksData]>.create { observer -> Disposable in
            guard let updateTaskIndex = self.tasks.firstIndex(where: { $0.id == task.id }) else {
                return Disposables.create()
            }
        
            self.tasks[updateTaskIndex].isComplete = task.isComplete
            self.tasksSubject.onNext(self.tasks)
            observer.onNext(self.tasks)
            
            return Disposables.create()
        }
    }
    
    func deleteTask(task: TasksData) -> Observable<[TasksData]> {
        return Observable<[TasksData]>.create { observer -> Disposable in
            self.tasks = self.tasks.filter { $0.id != task.id }
            self.tasksSubject.onNext(self.tasks)
            observer.onNext(self.tasks)
            
            return Disposables.create()
        }
    }
    
    func deleteAll() -> Observable<[TasksData]> {
        return Observable<[TasksData]>.create { observer -> Disposable in
            self.tasks.removeAll()
            self.tasksSubject.onNext(self.tasks)
            observer.onNext(self.tasks)
            
            return Disposables.create()
        }
    }
    
    
}
