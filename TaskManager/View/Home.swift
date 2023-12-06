//
//  Home.swift
//  TaskManager
//
//  Created by Alejandro Chinchilla Robayo on 12/5/23.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    var body: some View {
        ScrollView{
            // MARK: Lazy Stack With Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]){
                Section{
                    
                    // MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(taskModel.currentWeek, id: \.self){day in
                                VStack(spacing: 10){
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                    // EE will return day as MON,TUE,... etc
                                    Text(taskModel.extractDate(date: day, format: "EEE")).font(.system(size: 14))
                                    
                                    Circle().fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1:0)
                                }
                                // MARK: Foreground Style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                //MARK: Capsule Shape
                                .frame(width: 45,height: 90).background(
                                    ZStack{
                                        // MARK: Matched Geometry Effect
                                        if taskModel.isToday(date: day){
                                            Capsule().fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                        
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                                
                            }
                        }.padding(.horizontal)
                        
                    }
                    TasksView()
                }header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container,edges: .top)
    }
    
    // MARK: Tasks View
    func TasksView()->some View{
        LazyVStack(spacing: 25){
            if let tasks = taskModel.filteredTask{
                if tasks.isEmpty{
                    Text("No tasks found!!!")
                        .fontWeight(.light)
                        .offset(y: 100)
                }else{
                    ForEach(tasks){task in
                        TaskCardView(task: task)
                    }
                }
            }
            else{
                // MARK: Progress View
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        // MARK: Updating Tasks
        .onChange(of: taskModel.currentDay){newValue in
            taskModel.filterTodayTask()
            
        }.onAppear{
            taskModel.filterTodayTask()
        }
    }
    
    // MARK: Task Card View
    
    func TaskCardView(task: Task) -> some View{
        HStack(alignment: .top, spacing: 30){
            VStack(spacing: 10){
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black,lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate) ? 0.8 : 1)
                Rectangle()
                    .fill()
                    .frame(width: 3)
            }
            
            VStack{
                HStack(alignment: .top, spacing: 10){
                    VStack(alignment: .leading, spacing: 12){
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
                if taskModel.isCurrentHour(date: task.taskDate){
                    // MARK: Team Members
                    HStack(spacing: 0){
                        HStack(spacing: -10){
                            ForEach(["User1","User2","User3"],id: \.self){user in
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                        Circle()
                                            .stroke(.black,lineWidth: 5)
                                    )
                            }
                        }
                        .hLeading()
                        // MARK: Check Button
                        Button {
                            
                        }label:{
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white,in: RoundedRectangle(cornerRadius: 10))
                        }
                    }.padding(.top)
                    
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate) ? 0 : 10)
            .hLeading()
            .background(Color.black.cornerRadius(25).opacity(taskModel.isCurrentHour(date: task.taskDate) ? 1 : 0))
        }
        .hLeading()
    }
    
    // MARK: Header
    func HeaderView() -> some View{
        HStack(spacing: 10){
            VStack(alignment: .leading, spacing: 10){
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                Text("Today").font(.largeTitle.bold())
            }.hLeading()
            
            Button(action: {
                
            }, label: {
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45,height: 45)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            })
            
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
    
}

// MARK: UI Design Helper functions
extension View{
    func hLeading()->some View{
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    func hTrailing()->some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    func hCenter()->some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: Safe Area
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        return safeArea
    }
}



#Preview {
    Home()
}