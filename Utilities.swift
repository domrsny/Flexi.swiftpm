//
//  Utilities.swift
//  Flexi
//
//  Created by Dominic Snyder on 11/1/24.
//

import SwiftUI

// MARK: - Save/Load Classes

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

// MARK: - Save/Load Tasks

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
