//
//  TasksModel.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/09.
//

import Foundation
import RxDataSources
import RxSwift

struct TasksData: Codable {
    var id: String
    var isComplete: Bool
    var task: String
    var priority: TasksPriority
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case isComplete = "isComplete"
        case task = "task"
        case priority = "priority"
    }
}

enum TasksPriority: Codable {
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

extension TasksData: IdentifiableType, Equatable {
    typealias Identity = String
    
    public var identity: String {
        return id
    }
    
    public static func ==(lhs: TasksData, rhs: TasksData) -> Bool {
        return lhs.id == rhs.id
    }
    
}
