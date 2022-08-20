//
//  TasksModel.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/09.
//

import Foundation
import RxDataSources
import RxSwift
import RealmSwift

//class Person: Object {
//    private var _day: WeekDay?
//    var birthday: WeekDay? {
//        get {
//            if let resolTypeRaw = birthdayRaw  {
//                _day = WeekDay(rawValue: resolTypeRaw)
//                return _day
//            }
//            return .Sunday
//        }
//        set {
//            birthdayRaw = newValue?.rawValue
//            _day = newValue
//        }
//    }
//
//    dynamic var id: String? = nil
//
//
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//}

class TasksData: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var task: String = ""
    @objc dynamic var priorityRaw: String? = nil
    
    var priority: TasksPriority? {
        get {
            if let resolTypeRaw = priorityRaw  {
                return TasksPriority(rawValue: resolTypeRaw)
            }
            return .none
        }
        set {
            priorityRaw = newValue?.rawValue
        }
    }
    
    convenience init(id: String, isComplete: Bool, task: String, priority: TasksPriority) {
        self.init()
        self.id = id
        self.isComplete = isComplete
        self.task = task
        self.priority = TasksPriority.init(rawValue: priority.rawValue)!
    }
}

enum TasksPriority: String {
    case high
    case normal
    case low
    case none
}

struct TasksSection {
    var header: String
    var items: [Item]
    var sectionId: String = UUID().uuidString
}

extension TasksSection: AnimatableSectionModelType {
    
    typealias Item = TasksData
    
    typealias Identity = String
    
    init(original: TasksSection, items: [TasksData]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return sectionId
    }
}

extension TasksData: IdentifiableType {
    typealias Identity = String
    
    public var identity: String {
        return id
    }
    
    public static func ==(lhs: TasksData, rhs: TasksData) -> Bool {
        return lhs.id == rhs.id
    }
    
}
