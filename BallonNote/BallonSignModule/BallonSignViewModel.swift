import SwiftUI

class BallonSignViewModel: ObservableObject {
    let contact = BallonSignModel()
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
}
