import SwiftUI
import Combine

struct BallonCard: Identifiable, Equatable {
    let id = UUID()
    let inspireId: String
    let name: String
    let ballons: [String]
}

class BallonMyBallonsViewModel: ObservableObject {
    @Published var isDetail = false
    @Published var cards: [BallonCard] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func delete(card: BallonCard, login: String) {
        NetworkManager.shared.deleteInspire(login: login, inspireId: card.inspireId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let self = self else { return }
                    if let index = self.cards.firstIndex(where: { existingCard in
                        existingCard.name == card.name &&
                        existingCard.ballons.count == card.ballons.count
                    }) {
                        self.cards.remove(at: index)
                    }
                case .failure(let error):
                    print("Ошибка удаления: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchCards(login: String) {
        NetworkManager.shared.getInspire(login: login) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let inspire):
                    let card = BallonCard(
                        inspireId: inspire.id,
                        name: inspire.name,
                        ballons: inspire.trought
                    )
                    self?.cards = [card]
                case .failure(let error):
                    print("Ошибка загрузки: \(error.localizedDescription)")
                }
            }
        }
    }

}




