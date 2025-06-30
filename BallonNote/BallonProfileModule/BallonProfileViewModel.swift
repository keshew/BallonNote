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
}
