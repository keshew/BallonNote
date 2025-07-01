import SwiftUI

struct InspireModel: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var trought: [String]
}

class BallonChooseViewModel: ObservableObject {
    let contact = BallonChooseModel()
    
    func saveInspire(
          login: String,
          name: String,
          thoughts: [String],
          completion: @escaping (Result<String, Error>) -> Void
      ) {
          let inspire = NetworkManager.InspireModel(
              id: UUID().uuidString,
              name: name,
              trought: thoughts
          )
          
          NetworkManager.shared.saveInspire(login: login, inspire: inspire) { result in
              DispatchQueue.main.async {
                  completion(result)
              }
          }
      }
}
