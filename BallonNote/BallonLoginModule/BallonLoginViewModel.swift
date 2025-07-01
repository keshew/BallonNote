import SwiftUI

class BallonLoginViewModel: ObservableObject {
    let contact = BallonLoginModel()
    @Published var email = ""
    @Published var password = ""
    @Published var isSign = false
     @Published var showAlert = false
     @Published var alertMessage = ""
    @Published var isTab = false
    
    func login() {
            guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                alertMessage = "Please fill in all fields."
                showAlert = true
                return
            }
            
        NetworkManager.shared.authorize(login: email, pass: password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.isTab = true
                        break
                    case .failure(let error):
                        if let networkError = error as? NetworkManager.NetworkError {
                            switch networkError {
                            case .serverError(let message):
                                self?.alertMessage = message
                            default:
                                self?.alertMessage = "Login failed. Please try again."
                            }
                        } else {
                            self?.alertMessage = "Login failed. Please try again."
                        }
                        self?.showAlert = true
                    }
                }
            }
        }
    }
