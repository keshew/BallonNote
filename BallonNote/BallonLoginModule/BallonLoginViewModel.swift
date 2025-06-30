import SwiftUI

class BallonLoginViewModel: ObservableObject {
    let contact = BallonLoginModel()
    @Published var email = ""
    @Published var password = ""
}
