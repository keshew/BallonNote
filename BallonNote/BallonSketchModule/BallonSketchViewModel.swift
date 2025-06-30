import SwiftUI

class BallonSketchViewModel: ObservableObject {
    let contact = BallonSketchModel()

    @Published var brushes: [Brush] = [
        Brush(name: "Тонкая", icon: "tool1", width: 2),
        Brush(name: "Средняя", icon: "tool2", width: 6),
        Brush(name: "Толстая", icon: "tool3", width: 12),
        Brush(name: "Кисть", icon: "tool4", width: 18)
    ]
    @Published var selectedBrush: Brush = Brush(name: "Средняя", icon: "pencil", width: 6)
    @Published var colors: [SketchColor] = [
        SketchColor(color: Color(red: 233/255, green: 145/255, blue: 165/255)),
        SketchColor(color: Color(red: 77/255, green: 168/255, blue: 65/255)),
        SketchColor(color: Color(red: 77/255, green: 145/255, blue: 211/255)),
        SketchColor(color: Color(red: 237/255, green: 75/255, blue: 62/255)),
        SketchColor(color: Color(red: 240/255, green: 208/255, blue: 45/255)),
        SketchColor(color: .black),
        SketchColor(color: .white)
    ]
    @Published var selectedColor: SketchColor = SketchColor(color: .black)
    @Published var lines: [Line] = []
    @Published var agaon = 1

    init() {
        self.selectedBrush = brushes.first!
    }
}

struct Line: Identifiable, Equatable {
    let id = UUID()
    var points: [CGPoint]
    var color: Color
    var width: CGFloat
}
