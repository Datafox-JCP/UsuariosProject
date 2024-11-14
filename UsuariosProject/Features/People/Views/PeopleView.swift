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
    @State private var showSuccess = false
    @State private var hasAppear = false
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    // MARK: Content
    var body: some View {
        NavigationStack {
            ZStack {
                background
                
                if vm.isLoading {
                    ProgressView()
                } else {
                    ScrollView  {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(vm.users, id: \.id) { user in
                                NavigationLink {
                                    DetailView(userId: user.id)
                                } label: {
                                    PersonItemView(user: user)
                                    // Verificar si se llego al final
                                        .task {
                                            if vm.hasReachEnd(of: user) && !vm.isFetching {
                                                await vm.fetchNextSetOfUsers()
                                            }
                                        }
                                } // Link
                            } // Loop
                        } // LVGrid
                        .padding()
                    } // Scroll
                    .overlay(alignment: .bottom) {
                        if vm.isFetching {
                            ProgressView()
                        }
                    }
                } // Condition
            } // ZStack
            .navigationTitle("Usuarios")
            .refreshable {
                Task {
                    await vm.fetchUsers()
                } // Task
            } // Refresheable
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    create
                } // Tool item
                
                ToolbarItem(placement: .topBarLeading) {
                    refresh
                } // Tool item
            } // Toolbar
            .task {
                if !hasAppear {
                    await vm.fetchUsers()
                    hasAppear = true
                } // Condition
            } // Task
            .sheet(isPresented: $showCreateUser) {
                CreateView {
                    haptic(.success)
                    withAnimation(.spring().delay(0.25)) {
                        showSuccess.toggle()
                    } // Animation
                } // Create
                    .presentationDetents([.medium, .large])
            } // Sheet
            .alert(isPresented: $vm.hasError, error: vm.error) {
                Button("Reintentar") {
                    Task {
                        await vm.fetchUsers()
                    } // Task
                } // Button
            } // Alert
            .overlay {
                if showSuccess {
                    CheckMarkView()
                        .transition(.scale.combined(with: .opacity)) // después de probar la animación de abajo
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.spring()) {
                                    self.showSuccess.toggle()
                                } // Animation
                            } // Dispatch
                        } // onAppear
                } // Condition
            } // Overlay
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
        .disabled(vm.isLoading)
    }
    
    var refresh: some View {
        Button {
            Task {
                await vm.fetchUsers()
            }
        } label: {
            Symbols.refresh
        }
        .disabled(vm.isLoading)
    }
}
