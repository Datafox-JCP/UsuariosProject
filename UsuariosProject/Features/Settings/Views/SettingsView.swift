//
//  SettingsView.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 11/11/24.
//

import SwiftUI

struct SettingsView: View {
    // MARK: Properties
    @AppStorage(UserDefaultsKeys.hapticEnabled) private var isHapticsEnabled = true
    
    // MARK: - View
    var body: some View {
        NavigationView {
            Form {
                haptics
            } // Form
            .navigationTitle("Configuración")
        } // Nav
    }
}

// MARK: - Previews
#Preview("Light") {
    NavigationView {
        SettingsView()
    }
}

#Preview("Dark") {
    NavigationView {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}

// MARK: - Extensions
private extension SettingsView {
    var haptics: some View {
//        Toggle("Activar haptics", isOn: .constant(true))
        Toggle("Activar haptics", isOn: $isHapticsEnabled)
    }
}
