import SwiftUI

struct BallonCard: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let ballons: [String] // ["ball1", ...]
}

class BallonMyBallonsViewModel: ObservableObject {
    @Published var cards: [BallonCard] = [
        BallonCard(name: "Name name name", ballons: ["ball1", "ball2", "ball3", "ball4", "ball5", "ball6"]),
        BallonCard(name: "Name name name", ballons: ["ball1", "ball2", "ball3", "ball4", "ball5", "ball6"]),
        BallonCard(name: "Name name name", ballons: ["ball1", "ball2", "ball3", "ball4", "ball5", "ball6"])
    ]
    
    func delete(card: BallonCard) {
        if let index = cards.firstIndex(of: card) {
            cards.remove(at: index)
        }
    }
}
