import SwiftUI

class BallonDetailBallonViewModel: ObservableObject {
    @Published var balloons: [BalloonItem] = [
        BalloonItem(color: .green, text: "texttext\ntexttext"),
        BalloonItem(color: .yellow, text: "texttext\ntexttext"),
        BalloonItem(color: .orange, text: "texttext\ntexttext"),
        BalloonItem(color: .blue, text: "texttext\ntexttext"),
        BalloonItem(color: .purple, text: "texttext\ntexttext")
    ]
    @Published var selectedBalloonID: UUID? = nil
    
    func selectBalloon(_ balloon: BalloonItem) {
        if selectedBalloonID == balloon.id {
            selectedBalloonID = nil
        } else {
            selectedBalloonID = balloon.id
        }
    }
    
    func deleteSelectedBalloon() {
        guard let id = selectedBalloonID else { return }
        balloons.removeAll { $0.id == id }
        selectedBalloonID = nil
    }
}
