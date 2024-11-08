//
//  PillView.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 29/10/24.
//

import SwiftUI

struct PillView: View {
    // MARK: Properties
    let id: Int
    
    // MARK: Content
    var body: some View {
        Text("\(id)")
            .font(.system(.caption, design: .rounded))
            .bold()
            .foregroundStyle(.white)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(Theme.pill, in: Capsule())
    }
}

// MARK: Previews
#Preview("Light", traits: .sizeThatFitsLayout) {
    PillView(id: 1)
}

#Preview("Dark", traits: .sizeThatFitsLayout) {
    PillView(id: 1)
        .preferredColorScheme(.dark)
}

