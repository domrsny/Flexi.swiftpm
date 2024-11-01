//
//  SwiftUIView.swift
//  Flexi
//
//  Created by Dominic Snyder on 11/1/24.
//

import SwiftUI

struct EditClassSheet: View {
    @Binding var newClassName: String
    @Binding var newClassColor: Color
    @Binding var isPresented: Bool
    let onSave: () -> Void
    let onDelete: () -> Void
    
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
            
            HStack {
                Button("Save Changes") {
                    onSave()
                    isPresented = false
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
                
                Button(action: {
                    onDelete()
                    isPresented = false
                }) {
                    Label("Delete Class", systemImage: "trash")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .labelStyle(.iconOnly)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}
