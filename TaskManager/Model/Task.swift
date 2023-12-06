//
//  Task.swift
//  TaskManager
//
//  Created by Alejandro Chinchilla Robayo on 12/5/23.
//

import SwiftUI

struct Task: Identifiable{
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
