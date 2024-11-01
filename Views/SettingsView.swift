//
//  SwiftUIView.swift
//  Flexi
//
//  Created by Dominic Snyder on 10/17/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var classes: [Class] = loadClasses()
    @State private var newClassName: String = ""
    @State private var newClassColor: Color = .blue
    @State private var showAddClassSheet = false
    @State private var showEditClassSheet = false
    @State private var editingClassIndex: Int?
    
    var body: some View {
        VStack {
            Text("Manage Classes")
                .font(.largeTitle)
                .padding()
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(classes.indices, id: \.self) { index in
                        let classItem = classes[index]
                        
                        HStack {
                            Circle()
                                .fill(classItem.color)
                                .frame(width: 20, height: 20)
                            Text(classItem.name)
                            Spacer()
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .clipShape(Capsule())
                        .onTapGesture {
                            editingClassIndex = index
                            newClassName = classItem.name
                            newClassColor = classItem.color
                            showEditClassSheet.toggle()
                        }
                    }
                    .onDelete(perform: deleteClass)
                    .padding(.horizontal)
                }
            }
            
            Button(action: { showAddClassSheet.toggle() }) {
                Label("Add Class", systemImage: "plus.circle")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .padding()
        }
        .sheet(isPresented: $showAddClassSheet) {
            AddClassSheet(newClassName: $newClassName, newClassColor: $newClassColor, isPresented: $showAddClassSheet) {
                addClass()
            }
        }
        .sheet(isPresented: $showEditClassSheet) {
            EditClassSheet(newClassName: $newClassName, newClassColor: $newClassColor, isPresented: $showEditClassSheet, onSave: {
                editClass()
            }, onDelete: {
                if let index = editingClassIndex {
                    deleteClass(at: IndexSet(integer: index))
                }
            })
        }
    }
    
    func addClass() {
        let newClass = Class(name: newClassName, color: newClassColor)
        classes.append(newClass)
        saveClasses(classes)
        resetNewClassData()
    }
    
    func editClass() {
        if let index = editingClassIndex {
            classes[index].name = newClassName
            classes[index].color = newClassColor
            saveClasses(classes)
            resetEditingState()
        }
    }
    
    func deleteClass(at offsets: IndexSet) {
        if let index = editingClassIndex {
            classes.remove(atOffsets: offsets)
            saveClasses(classes)
            resetEditingState()
        }
    }
    
    func resetNewClassData() {
        newClassName = ""
        newClassColor = .blue
    }
    
    func resetEditingState() {
        editingClassIndex = nil
        showEditClassSheet = false
    }
}

#Preview {
    SettingsView()
}
