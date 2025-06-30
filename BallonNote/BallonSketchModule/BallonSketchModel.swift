import SwiftUI

struct BallonSketchModel {
 
}

struct Brush: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let icon: String 
    let width: CGFloat
}

struct SketchColor: Identifiable, Equatable {
    let id = UUID()
    let color: Color
}


