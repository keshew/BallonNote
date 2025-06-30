import SwiftUI

class BallonChooseSketchViewModel: ObservableObject {
    let contact = BallonChooseSketchModel()
    @Published var nameOfInspire = ""
}
