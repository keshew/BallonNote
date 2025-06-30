import SwiftUI

class BallonInspireViewModel: ObservableObject {
    let contact = BallonInspireModel()
    @Published var nameOfInspire = ""
    @Published var thoughts: [String] = [""]
}
