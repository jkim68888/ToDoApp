//
//  ViewModelType.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/09.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

enum ViewModelExecution {
    case trigger
    case success
    case fetch
    case error
}

