//
//  MyFitnessApp.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI
import SwiftData

@main
struct MyFitnessApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Restospect.self,
            Anaerobic.self,
            Cardio.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
