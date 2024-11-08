//
//  PeopleView.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 29/10/24.
//

import SwiftUI

struct PeopleView: View {
    // MARK: Properties
    @StateObject private var vm = UsersViewModel()

    @State private var showCreateUser = false
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    // MARK: Content
    var body: some View {
        NavigationStack {
            ZStack {
                background
                
                ScrollView  {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(vm.users, id: \.id) { user in
                            NavigationLink {
                                DetailView(userId: user.id)
                            } label: {
                                PersonItemView(user: user)
                            }
                        } // Loop
                    } // LVGrid
                    .padding()
                } // Scroll
            } // ZStack
            .navigationTitle("Usuarios")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    create
                }
            } // Toolbar
            .onAppear {
                vm.fetchUsers()
            } // onAppear
            .sheet(isPresented: $showCreateUser) {
                CreateView()
                    .presentationDetents([.medium, .large])
            } // Sheet
            .alert(isPresented: $vm.hasError, error: vm.error) {
                Button("Reintentar") {
                    vm.fetchUsers()
                }
            }
        } // Nav
    }
}

// MARK: Previews
#Preview("Light") {
    NavigationView {
        PeopleView()
    }
}

#Preview("Dark") {
    NavigationView {
        PeopleView()
            .preferredColorScheme(.dark)
    }
}

private extension PeopleView {
    
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    var create: some View {
        Button {
            showCreateUser.toggle()
        } label: {
            Symbols.plus
                .font(.system(.headline, design: .rounded))
                .bold()
        }
    }
}
