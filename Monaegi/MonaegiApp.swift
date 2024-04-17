import SwiftUI

@main
struct MonaegiApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var journalState = JournalState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(journalState)
        }
    }
}
