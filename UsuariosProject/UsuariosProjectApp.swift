//
//  UsuariosProjectApp.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 12/10/24.
//

import SwiftUI

@main
struct UsuariosProjectApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                PeopleView()
                    .tabItem {
                        Symbols.person
                        Text("Home")
                    }
                
                SettingsView()
                    .tabItem{
                        Symbols.gear
                        Text("Settings")
                    }
            }
        }
    }
}

/*
 1 TabView en UsuariosProjectApp
 2 PeopleView en Views
 */
