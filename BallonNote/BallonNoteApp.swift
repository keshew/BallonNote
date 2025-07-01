import SwiftUI

@main
struct BallonNoteApp: App {
    var body: some Scene {
        WindowGroup {
            if UserDefaultsManager().checkLogin() {
                BallonTabBarView()
            } else {
                if UserDefaultsManager().isFirstLaunch() {
                    BallonOnboardingView()
                } else {
                    BallonLoginView()
                        .onAppear() {
                            UserDefaultsManager().quitQuest()
                        }
                }
            }
        }
    }
}
