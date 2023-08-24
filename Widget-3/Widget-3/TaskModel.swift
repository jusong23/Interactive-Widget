//
//  TaskModel.swift
//  Widget-3
//
//  Created by jusong on 2023/08/24.
//

import SwiftUI

struct TaskModel: Identifiable {
    var id: String = UUID().uuidString
    var taskTitle: String
    var isCompleted: Bool = false
}

class TaskDataModel {
    static let shared = TaskDataModel() // API Call 가능
    
    var tasks : [TaskModel] = [
        .init(taskTitle: "Record Video!"),
        .init(taskTitle: "Edit Video!"),
        .init(taskTitle: "Publish Video!")
    ]
}
