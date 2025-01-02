//
//  SwiftUIView.swift
//  Flexi
//
//  Created by Dominic Snyder on 10/17/24.
//

import SwiftUI

// Main view for managing tasks
struct TaskView: View {
    @State private var tasks: [Task] = loadTasks()
    @State private var classes: [Class] = loadClasses()
    @State private var newTaskTitle: String = ""
    @State private var newTaskDueDate: Date = Date()
    @State private var assignedClassID: UUID?
    @State private var showAddTaskSheet: Bool = false
    @State private var showCompletedTasks: Bool = true
    @State private var showEditTaskSheet: Bool = false
    @State private var editingTaskIndex: Int?
    @State private var sortBy: String = "dueDate" // Default sorting by dueDate
    @State private var sortOrderAscending: Bool = true // Default ascending order
    
    
    let sortByKey = "sortByKey"
    let sortOrderAscendingKey = "sortOrderAscendingKey" // Used for save/load purposes
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Your Tasks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            .padding(.horizontal)
            // Scrollable Task List
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(tasks.indices, id: \.self) { index in
                        if showCompletedTasks || !tasks[index].isCompleted {
                            let task = tasks[index]
                            let classColor = classes.first { $0.id == task.assignedClassID}?.color ?? Color.clear
                            
                            HStack {
                                Text(task.title)
                                    .strikethrough(tasks[index].isCompleted)
                                Spacer()
                                Text(tasks[index].dueDate, style: .date)
                                Toggle(isOn: $tasks[index].isCompleted) {
                                    Label("Completed", systemImage: tasks[index].isCompleted ? "checkmark.circle" : "circle")
                                        .labelStyle(.iconOnly)
                                }
                                    .onChange(of: tasks[index].isCompleted) { _, _ in
                                        saveTasks(tasks)
                                    }
                                    .toggleStyle(.button)
                                    .dynamicTypeSize(.xxxLarge)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(.capsule)
                            .overlay(
                                Capsule()
                                    .stroke(classColor, lineWidth: 4) // Border with class color
                            )
                            .onTapGesture {
                                // Set up the class for editing
                                editingTaskIndex = index
                                newTaskTitle = tasks[index].title
                                newTaskDueDate = tasks[index].dueDate
                                assignedClassID = tasks[index].assignedClassID
                                showEditTaskSheet.toggle()
                            }
                        }
                    }
                }
                .padding([.top, .leading, .trailing])
            }
            .onChange(of: sortBy) { _, _ in sortTasks() }
            .onChange(of: sortOrderAscending) { _, _ in sortTasks() }
            .onAppear {
                loadSortingPreferences()
                sortTasks()
            }
            
            // Add Task and Show/Hide Completed buttons anchored at the bottom
            HStack {
                Button(action: {
                    showAddTaskSheet.toggle()
                }) {
                    Label("Add Task", systemImage: "plus.circle")
                        .font(.headline)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.blue)
                        .clipShape(.capsule)
                }
                
                // Show/Hide Completed Tasks Button
                Button(action: {
                    showCompletedTasks.toggle()
                }) {
                    Image(systemName: showCompletedTasks ? "eye.fill" : "eye.slash.fill")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(.capsule)
                }
                // Sort By Menu
                Menu {
                    // Sorting Options
                    Button(action: {
                        sortBy = "title"
                        sortTasks()
                    }) {
                        Label("Sort by Title", systemImage: "textformat")
                    }
                    
                    Button(action: {
                        sortBy = "dueDate"
                        sortTasks()
                    }) {
                        Label("Sort by Due Date", systemImage: "calendar")
                    }
                    
                    Divider()
                    
                    // Ascending/Descending Toggle
                    Button(action: {
                        sortOrderAscending.toggle()
                        sortTasks()
                    }) {
                        Label(sortOrderAscending ? "Descending Order" : "Ascending Order", systemImage: sortOrderAscending ? "arrow.down" : "arrow.up")
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .clipShape(.capsule)
                }
                
            }
            .padding([.leading, .bottom, .trailing])
        }
        .sheet(isPresented: $showAddTaskSheet) {
            // New Task Sheet
            AddTaskSheet(newTaskTitle: $newTaskTitle, newTaskDueDate: $newTaskDueDate, assignedClassID: $assignedClassID, classes: classes) {
                addTask()
            }
        }
        .sheet(isPresented: $showEditTaskSheet) {
            // Edit Task Sheet
            EditTaskSheet(newTaskTitle: $newTaskTitle, newTaskDueDate: $newTaskDueDate, assignedClassID: $assignedClassID, classes: classes, onSave: {
                editTask()
            }, onDelete: {
                deleteTask()
            })
        }
    }
    // Function to add a new task
    func addTask() {
        let newTask = Task(title: newTaskTitle, dueDate: newTaskDueDate, isCompleted: false, assignedClassID: assignedClassID)
        tasks.append(newTask)
        saveTasks(tasks)
        resetTaskInput()
    }

    // Function to edit an existing task
    func editTask() {
        if let index = editingTaskIndex {
            tasks[index].title = newTaskTitle
            tasks[index].dueDate = newTaskDueDate
            tasks[index].assignedClassID = assignedClassID
            saveTasks(tasks)
            resetTaskInput()
        }
    }
    
    // Function to delete the selected task
    func deleteTask() {
        if let index = editingTaskIndex {
            tasks.remove(at: index)
            saveTasks(tasks)
            resetTaskInput()
        }
    }
    
    func resetTaskInput() {
        newTaskTitle = ""
        newTaskDueDate = Date()
        assignedClassID = nil
        editingTaskIndex = nil
        showAddTaskSheet = false
        showEditTaskSheet = false
    }
    
    func sortTasks() {
        switch sortBy {
        case "title":
            tasks.sort {
                sortOrderAscending ? $0.title < $1.title : $0.title > $1.title
            }
        case "dueDate":
            tasks.sort {
                sortOrderAscending ? $0.dueDate < $1.dueDate : $0.dueDate > $1.dueDate
            }
        default:
            break
        }
        saveSortingPreferences()
    }
    
    func saveSortingPreferences() {
        UserDefaults.standard.set(sortBy, forKey: sortByKey)
        UserDefaults.standard.set(sortOrderAscending, forKey: sortOrderAscendingKey)
    }

    func loadSortingPreferences() {
        if let savedSortBy = UserDefaults.standard.string(forKey: sortByKey) {
            sortBy = savedSortBy
        }
        sortOrderAscending = UserDefaults.standard.bool(forKey: sortOrderAscendingKey)
    }
}

#Preview {
    TaskView()
}
