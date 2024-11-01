//
//  File.swift
//  Flexi
//
//  Created by Dominic Snyder on 11/1/24.
//

import SwiftUI

// Class model
struct Class: Identifiable, Codable {
    var id = UUID()
    var name: String
    var color: Color
}

// Task model
struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var dueDate: Date
    var isCompleted: Bool = false
    var assignedClassID: UUID? // Adds a classID to assign a task to a class
}

// Extend Color to support Codable
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
