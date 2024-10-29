import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab ("Summary", systemImage: "rectangle.3.group") {
                SummaryView()
            }
            Tab ("Tasks", systemImage: "checkmark.circle") {
                TaskView()
            }
            Tab ("Calendar", systemImage: "calendar.circle") {
                CalendarView()
            }
            Tab ("Settings", systemImage: "gearshape") {
                SettingsView()
            }
        }
    }
}
