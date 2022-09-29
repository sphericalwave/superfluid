//
//  superfluidApp.swift
//  superfluid
//
//  Created by Aaron Anthony on 2022-09-29.
//

import SwiftUI

@main
struct superfluidApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
