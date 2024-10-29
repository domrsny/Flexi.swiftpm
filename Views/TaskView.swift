//
//  SwiftUIView.swift
//  Flexi
//
//  Created by Dominic Snyder on 10/17/24.
//

import SwiftUI

// Task model
struct Task: Codable, Identifiable {
    var id = UUID()
    var title: String
    var dueDate: Date
    var isCompleted: Bool
}

// Save/load tasks functions
func saveTasks(_ tasks: [Task]) {
    if let encoded = try? JSONEncoder().encode(tasks) {
        UserDefaults.standard.set(encoded, forKey: "tasks")
    }
}

func loadTasks() -> [Task] {
    if let data = UserDefaults.standard.data(forKey: "tasks"),
        let decoded = try? JSONDecoder().decode([Task].self, from: data) {
        return decoded
    }
    return []
}

// Main view for managing tasks
struct TaskView: View {
    @State private var tasks: [Task] = loadTasks()
    @State private var newTaskTitle: String = ""
    @State private var newTaskDueDate: Date = Date()
    @State private var showAddTaskSheet: Bool = false
    @State private var showCompletedTasks: Bool = true
    @State private var showEditTaskSheet: Bool = false
    @State private var editingIndex: Int?
    
    var body: some View {
        VStack {
            Text("Your Tasks")
                .font(.largeTitle)
                .padding()
            // Scrollable Task List
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(tasks.indices, id: \.self) { index in
                        if showCompletedTasks || !tasks[index].isCompleted {
                            HStack {
                                Text(tasks[index].title)
                                    .strikethrough(tasks[index].isCompleted)
                                Spacer()
                                Text(tasks[index].dueDate, style: .date)
                                Toggle("Completed", isOn: $tasks[index].isCompleted)
                                    .onChange(of: tasks[index].isCompleted) { _, _ in
                                        saveTasks(tasks)
                                    }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(.capsule)
                            .onTapGesture {
                                // Set up the class for editing
                                editingIndex = index
                                newTaskTitle = tasks[index].title
                                newTaskDueDate = tasks[index].dueDate
                                showEditTaskSheet.toggle()
                            }
                        }
                    }
                }
                .padding(.horizontal)
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
                .padding(.trailing)
            }
            .padding([.leading, .bottom, .trailing])
        }
        .sheet(isPresented: $showAddTaskSheet) {
            // New Task Sheet
            AddTaskSheet(newTaskTitle: $newTaskTitle, newTaskDueDate: $newTaskDueDate) {
                addTask()
            }
        }
        .sheet(isPresented: $showEditTaskSheet) {
            // Edit Task Sheet
            EditTaskSheet(newTaskTitle: $newTaskTitle, newTaskDueDate: $newTaskDueDate) {
                editTask()
            }
        }
    }
    // Function to add a new task
    func addTask() {
        let newTask = Task(title: newTaskTitle, dueDate: newTaskDueDate, isCompleted: false)
        tasks.append(newTask)
        saveTasks(tasks)
        newTaskTitle = ""
        newTaskDueDate = Date()
    }

    // Function to edit an existing task
    func editTask() {
        if let index = editingIndex {
            tasks[index].title = newTaskTitle
            tasks[index].dueDate = newTaskDueDate
            saveTasks(tasks)
            editingIndex = nil
        }
    }
}

// Add task sheet
struct AddTaskSheet: View {
    @Binding var newTaskTitle: String
    @Binding var newTaskDueDate: Date
    let onSave: () -> Void

    var body: some View {
        VStack {
            Text("Add New Task")
                .font(.title)
                .padding()

            TextField("Task Title", text: $newTaskTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Due Date", selection: $newTaskDueDate, displayedComponents: .date)
                .padding()

            Button("Save Task") {
                onSave()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }
}

// Edit task sheet
struct EditTaskSheet: View {
    @Binding var newTaskTitle: String
    @Binding var newTaskDueDate: Date
    let onSave: () -> Void

    var body: some View {
        VStack {
            Text("Edit Task")
                .font(.title)
                .padding()

            TextField("Task Title", text: $newTaskTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Due Date", selection: $newTaskDueDate, displayedComponents: .date)
                .padding()

            Button("Save Changes") {
                onSave()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    TaskView()
}
