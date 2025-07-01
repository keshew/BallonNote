import SwiftUI
import Combine

class BallonMySketchViewModel: ObservableObject {
    @Published var isDetail = false
    @Published var cards: [BallonCard2] = []

     func fetchCards(login: String) {
         NetworkManager.shared.getSketches(login: login) { [weak self] result in
             DispatchQueue.main.async {
                 switch result {
                 case .success(let sketches):
                     self?.cards = sketches.compactMap { sketchResponse in
                         let imagesData = sketchResponse.images.compactMap { Data(base64Encoded: $0) }
                         return BallonCard2(
                             name: sketchResponse.name,
                             ballons: imagesData
                         )
                     }
                 case .failure(let error):
                     print("Ошибка загрузки скетчей: \(error.localizedDescription)")
                 }
             }
         }
     }
    
    func delete(card: BallonCard2) {
        if let index = cards.firstIndex(of: card) {
            cards.remove(at: index)
        }
    }
}

