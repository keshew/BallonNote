import SwiftUI

struct BallonSketchView: View {
    @StateObject var ballonSketchModel =  BallonSketchViewModel()

    var body: some View {
        Text("Hey, Genius")
    }
}

#Preview {
    BallonSketchView()
}

