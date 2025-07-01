import SwiftUI

class BallonProfileViewModel: ObservableObject {
    let contact = BallonProfileModel()
    @Published var isNotif: Bool {
        didSet {
            UserDefaults.standard.set(isNotif, forKey: "isNotif")
        }
    }
    
    @Published var isEmail: Bool {
        didSet {
            UserDefaults.standard.set(isEmail, forKey: "isEmail")
        }
    }
    
    init() {
        self.isNotif = UserDefaults.standard.bool(forKey: "isNotif")
        self.isEmail = UserDefaults.standard.bool(forKey: "isEmail")
    }
    
    func deleteAccount(completion: @escaping (Result<String, Error>) -> Void) {
        guard let login = UserDefaults.standard.string(forKey: "currentEmail") else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        NetworkManager.shared.deleteAccount(login: login) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func changeUsername(login: String, newName: String, completion: @escaping (Result<String, Error>) -> Void) {
        NetworkManager.shared.changeUsername(login: login, newName: newName, completion: completion)
    }
    
    func changeEmail(login: String, newEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
        NetworkManager.shared.changeEmail(login: login, newEmail: newEmail, completion: completion)
    }
}
