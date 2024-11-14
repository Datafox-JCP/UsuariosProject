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
    
    @FocusState private var focusedField: Field?
    
    @StateObject private var vm = CreateViewModel()
    
    let successfullAction: () -> Void // Closure
    
    // MARK: - Content
    var body: some View {
        NavigationView {
            Form {
                Section {
                    firstname
                    lastname
                    job
                } footer: {
//                    Text("<Error aquí>")
//                        .foregroundStyle(.red)
                    if case .validation(let err) = vm.error,
                       let errorDesc = err.errorDescription {
                        Text(errorDesc)
                            .foregroundStyle(.red)
                    }
                } // Section fields
                
                Section {
                    submit
                } // Section
            } // Form
            .disabled(vm.state == .submitting)
            .navigationTitle("Alta")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    close
                }
            } // Toolbar
            .onChange(of: vm.state) {
                if vm.state == .succesful {
                    dismiss()
                    successfullAction()
                }
            } // onChange
            .alert(isPresented: $vm.hasError, error: vm.error) { }
            .overlay {
                if vm.state == .submitting {
                    ProgressView()
                }
            } // Overlay
        } // NAV
    }
}

// MARK: - Fields
extension CreateView {
    enum Field: Hashable {
        case firstName
        case lastName
        case job
    }
}

// MARK: - Previews
#Preview("Light") {
    NavigationView {
        CreateView {}
    }
}

#Preview("Dark") {
    NavigationView {
        CreateView {}
            .preferredColorScheme(.dark)
    }
}

private extension CreateView {
    var firstname: some View {
        TextField("Nombre", text: $vm.user.firstName)
            .focused($focusedField, equals: .firstName)
    }
    
    var lastname: some View {
        TextField("Apellidos", text: $vm.user.lastName)
            .focused($focusedField, equals: .lastName)
    }
    
    var job: some View {
        TextField("Trabajo", text: $vm.user.job)
            .focused($focusedField, equals: .job)
    }
    
    var submit: some View {
        Button("Enviar") {
            focusedField = nil
            Task {
                await vm.create()
            }
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
