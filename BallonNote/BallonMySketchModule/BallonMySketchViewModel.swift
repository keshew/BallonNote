import SwiftUI
import Combine

class BallonMySketchViewModel: ObservableObject {
    @Published var cards: [BallonCard2] = []
    @Published var isDetail = false
    func fetchCards(login: String) {
        NetworkManager.shared.getSketches(login: login) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sketches):
                    self?.cards = sketches.compactMap { sketchResponse in
                        let imagesData = sketchResponse.images.compactMap { Data(base64Encoded: $0) }
                        return BallonCard2(
                            sketchId: sketchResponse.id,
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
    
    func delete(card: BallonCard2, login: String, sketchId: String) {
        NetworkManager.shared.deleteSketch(login: login, sketchId: sketchId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self?.cards.firstIndex(of: card) {
                        self?.cards.remove(at: index)
                    }
                case .failure(let error):
                    print("Ошибка удаления зарисовки: \(error.localizedDescription)")
                }
            }
        }
    }
}


