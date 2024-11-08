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
//                ContentView()
                PeopleView()
                    .tabItem {
                        Symbols.person
                        Text("Home")
                    }
            }
        }
    }
}

/*
 1 TabView en UsuariosProjectApp
 2 PeopleView en Views
 */
