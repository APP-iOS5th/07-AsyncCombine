//
//  EnvironmentObjectView.swift
//  StateManagement
//
//  Created by Jungman Bae on 6/17/24.
//

import SwiftUI


class UserProfile: ObservableObject {
    @Published var name: String
    @Published var favoriteProgrammingLanguage: String
    @Published var favoriteColor: Color
    
    init(name: String, favoriteProgrammingLanguage: String, favoriteColor: Color) {
        self.name = name
        self.favoriteProgrammingLanguage = favoriteProgrammingLanguage
        self.favoriteColor = favoriteColor
    }
}

struct EnvironmentObjectView: View {
    @StateObject var profile = UserProfile(name: "Peter",
                                           favoriteProgrammingLanguage: "Swift",
                                           favoriteColor: .pink)
    @State var isSettingShown = false
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    EnvironmentObjectView()
}
