//
//  SwiftUIView.swift
//  Flexi
//
//  Created by Dominic Snyder on 11/1/24.
//

import SwiftUI

struct AddTaskSheet: View {
    @Binding var newTaskTitle: String
    @Binding var newTaskDueDate: Date
    @Binding var assignedClassID: UUID?
    let classes: [Class]
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
            
            Picker("Assign to Class", selection: $assignedClassID) {
                Text("No Class").tag(UUID?.none)
                ForEach(classes) { classItem in
                    Text(classItem.name).tag(Optional(classItem.id))
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Button("Save Task") {
                onSave()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(.capsule)

            Spacer()
        }
        .padding()
    }
}
