import SwiftUI

class BallonOnboardingViewModel: ObservableObject {
    let contact = BallonOnboardingModel()
    @Published var currentIndex = 0
}
