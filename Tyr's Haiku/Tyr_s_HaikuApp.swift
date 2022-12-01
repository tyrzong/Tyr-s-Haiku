//
//  Tyr_s_HaikuApp.swift
//  Tyr's Haiku
//
//  Created by Tyr Zong on 11/30/22.
//

import SwiftUI

@main
struct Tyr_s_HaikuApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
