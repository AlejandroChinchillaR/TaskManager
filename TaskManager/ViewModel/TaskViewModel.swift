//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Alejandro Chinchilla Robayo on 12/5/23.
//

import SwiftUI

class TaskViewModel: ObservableObject{
    @Published var storedTask: [Task] = [
        Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: Date().timeIntervalSince1970 + 360)),
        Task(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week", taskDate: .init(timeIntervalSince1970: 1701826498)),
        Task(taskTitle: "Prototype", taskDescription: "Make and send prototype", taskDate: .init(timeIntervalSince1970: 1701826498 + 4360)),
        Task(taskTitle: "Team party", taskDescription: "Make fun with team mates", taskDate: .init(timeIntervalSince1970: 1701826498 + 4300)),
        Task(taskTitle: "Client meeting", taskDescription: "Explain project to client", taskDate: .init(timeIntervalSince1970: 1701826498)),
        Task(taskTitle: "Next Project", taskDescription: "Discuss next project with team", taskDate: .init(timeIntervalSince1970: 1701826498 + 120)),
        Task(taskTitle: "App proposal", taskDescription: "Meet client for next App Proposal", taskDate: .init(timeIntervalSince1970: 1701826498 - 4360))
    ]
    
    // MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    
    @Published var filteredTask: [Task]?
    
    // MARK: Initializing
    init(){
        fetchCurrentWeek()
    }
    
    // MARK: Filter Today Task
    func filterTodayTask(){
        DispatchQueue.global(qos: .userInteractive).async{
        let calendar = Calendar.current
        let filtered = self.storedTask.filter {
            return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
        }.sorted { task1, task2 in
            return task1.taskDate > task2.taskDate
        }
        
        DispatchQueue.main.async {
            withAnimation {
                self.filteredTask = filtered
            }
        }
    }
    }
    
    func fetchCurrentWeek(){
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeek.append(weekday)
            }
        }
    }
    
    //MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    //MARK: Checking if current Date is Today
    func isToday(date: Date)->Bool{
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    //MARK: Checking if the currentHour iss task Hour
    func isCurrentHour(date: Date)->Bool{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
    
    
    
}
