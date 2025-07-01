import SwiftUI

class BallonChooseSketchViewModel: ObservableObject {
    let contact = BallonChooseSketchModel()
    @Published var nameOfInspire = ""
    
    func saveSketch(login: String, sketch: NetworkManager.SketchModel, completion: @escaping (Result<String, Error>) -> Void) {
        NetworkManager.shared.saveSketch(login: login, sketch: sketch) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
