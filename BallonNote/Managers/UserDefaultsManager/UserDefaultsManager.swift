import SwiftUI

class UserDefaultsManager: ObservableObject {
    func isFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        let isFirstLaunch = defaults.bool(forKey: "isFirstLaunch")
        
        if !isFirstLaunch {
            defaults.set(true, forKey: "isFirstLaunch")
            return true
        }
        
        return false
    }
    
    func enterAsGuest() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "guest")
    }
    
    func isGuest() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "guest")
    }
    
    func quitQuest() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "guest")
    }
    
    func checkLogin() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "isLoggedIn")
    }
    
    func saveLoginStatus(_ isLoggedIn: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
    }
    
    func getEmail() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "currentEmail")
    }

    func getPassword() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "password")
    }
    
    func logout() {
        saveLoginStatus(false)
    }
    
    func saveCurrentEmail(_ email: String) {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "currentEmail")
    }
    
    func savePassword(_ password: String) {
        let defaults = UserDefaults.standard
        defaults.set(password, forKey: "password")
    }
    
    func deletePassword() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "password")
    }

    func deletePhone() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "currentEmail")
    }
}
