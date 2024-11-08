//
//  CreateView.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 31/10/24.
//

import SwiftUI

struct CreateView: View {
    // MARK: Properties
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vm = CreateViewModel()
    
    // MARK: - Content
    var body: some View {
        NavigationView {
            Form {
                firstname
                lastname
                job
                
                Section {
                    submit
                }
            } // Form
            .navigationTitle("Alta")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    close
                }
            } // Toolbar
            .onChange(of: vm.state) {
                if vm.state == .succesful {
                    dismiss()
                }
            }
            .alert(isPresented: $vm.hasError, error: vm.error) { }
        } // NAV
    }
}


// MARK: - Previews
#Preview {
    NavigationView {
        CreateView()
    }
}

private extension CreateView {
    var firstname: some View {
        TextField("Nombre", text: $vm.user.firstName)
    }
    
    var lastname: some View {
        TextField("Apellidos", text: $vm.user.lastName)
    }
    
    var job: some View {
        TextField("Trabajo", text: $vm.user.job)
    }
    
    var submit: some View {
        Button("Enviar") {
            vm.create()
        }
    }
    
    var close: some View {
        Button {
            dismiss()
        } label: {
            Symbols.close
                .font(.system(.headline, design: .rounded))
                .bold()
        }
    }
}
