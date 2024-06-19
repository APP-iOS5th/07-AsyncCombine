//
//  ContentView.swift
//  SignUpForm
//
//  Created by Jungman Bae on 6/18/24.
//

import SwiftUI
import Combine

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}

class SignUpFormViewModel: ObservableObject {
    typealias Available = Result<Bool, Error>
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    
    @Published var usernameMessage: String = ""
    @Published var passwordMessage: String = ""
    @Published var isValid: Bool = false
        
    private let authenticationService = AuthenticationService()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var isUsernameLengthValidPublisher: AnyPublisher<Bool, Never> = {
        $username.map { $0.count >= 3 }.eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> = {
        $password.map(\.isEmpty).eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordMatchingPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest($password, $passwordConfirmation)
            .map(==)
//          .map { $0 == $1 }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatchingPublisher)
            .map { !$0 && $1 }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isFormValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest3(isUsernameLengthValidPublisher, isUsernameAvailablePublisher, isPasswordValidPublisher)
            .map { isUsernameLengthValid, isUsernameAvailable, isPasswordValid in
                switch isUsernameAvailable {
                case .success(let isAvailable):
                    return isUsernameLengthValid && isAvailable && isPasswordValid
                case .failure:
                    return false
                }
            }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isUsernameAvailablePublisher: AnyPublisher<Available, Never> = {
        $username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { username -> AnyPublisher<Available, Never> in
                self.authenticationService.checkUserNameAvailable(userName: username)
                    .asResult()
            }
            .receive(on: DispatchQueue.main)
            .share()
            .print("share")
            .eraseToAnyPublisher()
    }()
    
//    func checkUserNameAvailable(_ userName: String) {
//        authenticationService.checkUserNameAvailableWithClosure(userName: userName) {
//            [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let isAvailable):
//                    self?.isUserNameAvailable = isAvailable
//                case .failure(let error):
//                    print("error: \(error)")
//                    self?.isUserNameAvailable = false
//                }
//            }
//        }
//    }
    
    init() {
        
        isFormValidPublisher.assign(to: &$isValid)
        
        Publishers.CombineLatest(isUsernameLengthValidPublisher, isUsernameAvailablePublisher)
            .map { isUsernameLengthValid, isUserNameAvailable in
                switch (isUsernameLengthValid, isUserNameAvailable) {
                case (false, _):
                    return "Username must be at least three characters!"
                case (_, .failure(let error)):
                    return "Error checking username availability: \(error.localizedDescription)"
                case (_, .success(false)):
                    return "This username is already taken."
                default:
                    return ""
                }
            }
            .assign(to: &$usernameMessage)
//        isUsernameLengthValidPublisher.map { $0 ? "" : "Username must be at least three characters!"}
//            .assign(to: &$usernameMessage)
        
        Publishers.CombineLatest(isPasswordEmptyPublisher, isPasswordMatchingPublisher)
            .map { isPasswordEmpty, isPasswordMatching in
                if isPasswordEmpty {
                    return "Password must not be empty"
                } else if !isPasswordMatching {
                    return "Passwords do not match"
                }
                return ""
            }
            .assign(to: &$passwordMessage)
    }
}

struct ContentView: View {
    @StateObject var viewModel = SignUpFormViewModel()
    
    var body: some View {
        Form {
            // Username
            Section {
                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } footer: {
                Text(viewModel.usernameMessage)
                    .foregroundStyle(Color.red)
            }
            // Password
            Section {
                SecureField("Password",
                            text: $viewModel.password)
                SecureField("Repeat password",
                            text: $viewModel.passwordConfirmation)
            } footer: {
                Text(viewModel.passwordMessage)
                    .foregroundColor(.red)
            }
            // Submit button
            Section {
                Button("Sign up") {
                    print("Signing up as \(viewModel.username)")
                }
                .disabled(!viewModel.isValid)
            }
        }
    }
}

#Preview {
    ContentView()
}
