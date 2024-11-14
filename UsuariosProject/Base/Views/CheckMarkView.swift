//
//  CheckMarkView.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 08/11/24.
//

import SwiftUI

struct CheckMarkView: View {
    var body: some View {
        Symbols.checkmark
            .font(.system(.largeTitle))
            .bold()
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview("Light") {
    CheckMarkView()
}

#Preview("Dark") {
    CheckMarkView()
        .preferredColorScheme(.dark)
}
