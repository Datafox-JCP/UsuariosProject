//
//  DetailView.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 30/10/24.
//

import SwiftUI

struct DetailView: View {
    // MARK: Properties
    @StateObject private var vm = DetailViewModel()
    
    let userId: Int
    
    // MARK: Content
    var body: some View {
        ZStack {
            background
            
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    avatar
                    
                    Group {
                        general
                        link
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 18)
                    .background(Theme.detailBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
                } // VStack
                .padding()
            } // Scroll
        } // ZStack
        .navigationTitle("Detalles")
        .onAppear {
            vm.fetchDetails(for: userId)
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
    }
}

// MARK: Previews
#Preview("Light") {
    
    var previewUserId: Int {
        let users = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        
        return users.data.first!.id
    }
    
    NavigationView {
        DetailView(userId: previewUserId)
    }
}

#Preview("Dark") {
    
    var previewUserId: Int {
        let users = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        
        return users.data.first!.id
    }
    
    NavigationView {
        DetailView(userId: previewUserId)
            .preferredColorScheme(.dark)
    }
}

private extension DetailView {
    
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    var general: some View {
        VStack(alignment: .leading, spacing: 8) {
            PillView(id: vm.userInfo?.data.id ?? 0)
            
            Group {
                firstname
                lastname
                email
            }
            .foregroundStyle(Theme.text)
        } // VStack
    }
    
    @ViewBuilder
    var avatar: some View {
        if let avatarAbsoluteString = vm.userInfo?.data.avatar,
           let avatarUrl = URL(string: avatarAbsoluteString) {
            AsyncImage(url: avatarUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    
    @ViewBuilder
    var link: some View {
        if let supportAbsoluteString = vm.userInfo?.support.url,
           let supportUrl = URL(string: supportAbsoluteString),
           let supportText = vm.userInfo?.support.text {
            
            Link(destination: supportUrl) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(supportText)
                        .foregroundStyle(Theme.text)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .multilineTextAlignment(.leading)
                    
                    Text(supportAbsoluteString)
                } // VStack
                
                Spacer()
                
                Symbols.link
                    .font(.system(.title3, design: .rounded))
            } // Link
           }
    }
    
    @ViewBuilder
    var firstname: some View {
        Text("Nombre")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        
        Text(vm.userInfo?.data.firstName ?? "")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Divider()
    }
    
    @ViewBuilder
    var lastname: some View {
        Text("Apellido")
            .font(.system(.body, design: .rounded).weight(.semibold))
        
        Text(vm.userInfo?.data.lastName ?? "")
            .font(.system(.body, design: .rounded))
        
        Divider()
    }
    
    @ViewBuilder
    var email: some View {
        Text("Email")
            .font(.system(.body, design: .rounded).weight(.semibold))
        
        Text(vm.userInfo?.data.email ?? "")
            .font(.system(.body, design: .rounded))
        
        Divider()
    }
}
