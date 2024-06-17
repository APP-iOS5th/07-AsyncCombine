//
//  ContentView.swift
//  SimpleView
//
//  Created by Jungman Bae on 6/17/24.
//

import SwiftUI

private class PersonViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    
    func save() {
        print("Save to disk")
    }
}

struct ContentView: View {
    @State var dirty = false
    @StateObject private var viewModel = PersonViewModel()
    
    var body: some View {
        Form {
            Section("\(self.dirty ? "* " : "")Input fields") {
                TextField("First name", text: $viewModel.firstName)
                    .onChange(of: viewModel.firstName) {
                        self.dirty = true
                    }
                    .onSubmit {
                        viewModel.save()
                        self.dirty = false
                    }
                TextField("Last name", text: $viewModel.lastName)
                    .onChange(of: viewModel.lastName) {
                        self.dirty = true
                    }
                    .onSubmit {
                        viewModel.save()
                        self.dirty = false
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
