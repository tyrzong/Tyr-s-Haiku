//
//  TabsView.swift
//  Tyr's Haiku
//
//  Created by Tyr Zong on 12/29/22.
//

import SwiftUI

struct TabsView: View {
    
    @StateObject private var dataController = DataController()
    @Environment(\.managedObjectContext) var managedObjContext
    var body: some View {
        TabView{
            ContentView()
                .tabItem{
                    Label("Haiku", systemImage: "square.and.pencil")
                }
            SettingsView()
                .tabItem{
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
