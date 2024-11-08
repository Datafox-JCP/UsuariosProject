//
//  PersonItemView.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 29/10/24.
//

import SwiftUI

struct PersonItemView: View {
    // MARK: Properties
    let user: User
    
    // MARK: Content
    var body: some View {
        VStack(spacing: .zero) {
            AsyncImage(url: .init(string: user.avatar)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 140)
                    .clipped()
            } placeholder: {
                ProgressView()
            }

            
            VStack {
                PillView(id: user.id)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(user.firstName) \(user.lastName)")
                    .foregroundStyle(Theme.text)
                    .font(.system(.body, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } // VStack
            .padding(.horizontal, 9)
            .padding(.vertical, 8)
            .background(Theme.detailBackground)
        } // VStack
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Theme.text.opacity(0.1), radius: 2, x:0, y: 1)
    }
}

// MARK: Previews
#Preview("Light") {
    
    var previewUser: User {
        let users = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        
        return users.data.first!
    }
    
    PersonItemView(user: previewUser)
        .frame(width: 250)
}

#Preview("Dark") {
    var previewUser: User {
        let users = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        
        return users.data.first!
    }
    
    PersonItemView(user: previewUser)
        .frame(width: 250)
        .preferredColorScheme(.dark)
}
