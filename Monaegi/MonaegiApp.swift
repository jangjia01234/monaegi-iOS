import SwiftUI

@main
struct MonaegiApp: App {
    @StateObject private var journalState = JournalState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(journalState)
        }
    }
}
