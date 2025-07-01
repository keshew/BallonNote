import SwiftUI

class BallonSignViewModel: ObservableObject {
    let contact = BallonSignModel()
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var isLogin = false
    @Published var isTab = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    func register() {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        NetworkManager.shared.register(login: email, pass: password, name: name, email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let successMessage):
                    print("Registration success: \(successMessage)")
                    self?.isTab = true
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }

    }
}
