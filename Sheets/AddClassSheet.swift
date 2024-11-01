//
//  SwiftUIView.swift
//  Flexi
//
//  Created by Dominic Snyder on 11/1/24.
//

import SwiftUI

struct AddClassSheet: View {
    @Binding var newClassName: String
    @Binding var newClassColor: Color
    @Binding var isPresented: Bool
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
                isPresented = false
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
            
            Spacer()
        }
        .padding()
    }
}
