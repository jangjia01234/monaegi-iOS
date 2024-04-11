//
//  MonaegiApp.swift
//  Monaegi
//
//  Created by Jia Jang on 4/11/24.
//

import SwiftUI

@main
struct MonaegiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
