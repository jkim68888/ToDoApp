//
//  TasksModel.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/09.
//

import Foundation

struct TasksData: Codable {
    var id: Int
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
}
