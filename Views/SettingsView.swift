//
//  SwiftUIView.swift
//  Flexi
//
//  Created by Dominic Snyder on 10/17/24.
//

import SwiftUI

// Classes model
struct Class: Identifiable, Codable {
    var id = UUID()
    var name: String
    var color: Color
}

// Convert Color to/fom UserDefaults
extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var (red, green, blue, opacity): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &opacity)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(opacity, forKey: .opacity)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(CGFloat.self, forKey: .red)
        let green = try container.decode(CGFloat.self, forKey: .green)
        let blue = try container.decode(CGFloat.self, forKey: .blue)
        let opacity = try container.decode(CGFloat.self, forKey: .opacity)
        self = Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct SettingsView: View {
    @State private var classes: [Class] = loadClasses()
    @State private var newClassName: String = ""
    @State private var newClassColor: Color = .blue
    @State private var showAddClassSheet: Bool = false
    @State private var showEditClassSheet: Bool = false
    @State private var editingClass: Class?
    
    var body: some View {
        VStack {
            Text("Manage Classes")
                .font(.largeTitle)
                .padding()
            
            // List of Classes
            VStack(spacing: 10) {
                ForEach(classes) { classItem in
                    HStack {
                        Circle()
                            .fill(classItem.color)
                            .frame(width: 20, height: 20)
                        Text(classItem.name)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.capsule)
                    .onTapGesture {
                        // Set up the calss for editing
                        editingClass = classItem
                        newClassName = classItem.name
                        newClassColor = classItem.color
                        showEditClassSheet.toggle()
                    }
                }
                .onDelete(perform: deleteClass)
                .padding(.horizontal)
            }
            
            // Add class button
            Button(action: {
                showAddClassSheet.toggle()
            }) {
                Label("Add Class", systemImage: "plus.circle")
                    .font(.headline)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(.capsule)
            }
            .padding()
        }
        .sheet(isPresented: $showAddClassSheet) {
            AddClassSheet(newClassName: $newClassName, newClassColor: $newClassColor) {
                addClass()
            }
        }
        .sheet(isPresented: $showEditClassSheet) {
            EditClassSheet(newClassName: $newClassName, newClassColor: $newClassColor) {
                editClass()
            }
        }
    }
    
    // Add class function
    func addClass() {
        let newClass = Class(name: newClassName, color: newClassColor)
        classes.append(newClass)
        saveClasses(classes)
        newClassName = ""
        newClassColor = .blue
    }
    
    // Function to edit an existing class
        func editClass() {
            if let editingClass = editingClass, let index = classes.firstIndex(where: { $0.id == editingClass.id }) {
                classes[index].name = newClassName
                classes[index].color = newClassColor
                saveClasses(classes)
                self.editingClass = nil
            }
        }
    
    // Delete class function
    func deleteClass(at offsets: IndexSet) {
        classes.remove(atOffsets: offsets)
        saveClasses(classes)
    }
}

// Sheet for adding a new class
struct AddClassSheet: View {
    @Binding var newClassName: String
    @Binding var newClassColor: Color
    let onSave: () -> Void
    
    var body: some View {
        VStack {
            Text("Add New Class")
                .font(.title)
                .padding()
            
            TextField("Class Name", text: $newClassName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ColorPicker("Choose Color", selection: $newClassColor)
                .padding()
            
            Button("Save Class") {
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

// Sheet for editing an existing class
struct EditClassSheet: View {
    @Binding var newClassName: String
    @Binding var newClassColor: Color
    let onSave: () -> Void
    
    var body: some View {
        VStack {
            Text("Edit Class")
                .font(.title)
                .padding()
            
            TextField("Class Name", text: $newClassName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ColorPicker("Choose Color", selection: $newClassColor)
                .padding()
            
            Button("Save Changes") {
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

// Save/load classes functions
func saveClasses(_ classes: [Class]) {
    if let encoded = try? JSONEncoder().encode(classes) {
        UserDefaults.standard.set(encoded, forKey: "classes")
    }
}

func loadClasses() -> [Class] {
    if let data = UserDefaults.standard.data(forKey: "classes"),
       let decoded = try? JSONDecoder().decode([Class].self, from: data) {
        return decoded
    }
    return []
}

#Preview {
    SettingsView()
}
