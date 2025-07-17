//
//  ExpenseTrackerAppApp.swift
//  ExpenseTrackerApp
//
//  Created by Balaji Venkatesh on 03/09/23.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerAppApp: App {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true

    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                IntroScreen()
            } else {
                ContentView()
            }
        }
        .modelContainer(for: [Expense.self, Category.self])
    }
}
