//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Vlad Vrublevsky on 23.04.2021.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    @StateObject var dataController: DataController
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController) // try to use self instead
    }
}
