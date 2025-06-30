import SwiftUI

struct Line: Identifiable, Equatable {
    let id = UUID()
    var points: [CGPoint]
    var color: Color
    var width: CGFloat
}

struct CanvasView: View {
    @Binding var lines: [Line]
    var selectedColor: Color
    var selectedWidth: CGFloat
    
    @State private var currentLine: Line = Line(points: [], color: .black, width: 2)
    
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    guard let first = line.points.first else { continue }
                    path.move(to: first)
                    for point in line.points.dropFirst() {
                        path.addLine(to: point)
                    }
                    context.stroke(path, with: .color(line.color), lineWidth: line.width)
                }
                // Текущая линия
                var path = Path()
                if let first = currentLine.points.first {
                    path.move(to: first)
                    for point in currentLine.points.dropFirst() {
                        path.addLine(to: point)
                    }
                    context.stroke(path, with: .color(currentLine.color), lineWidth: currentLine.width)
                }
            }
            .gesture(DragGesture(minimumDistance: 0.1)
                .onChanged { value in
                    let newPoint = value.location
                    if value.translation == .zero {
                        // Начало новой линии
                        currentLine = Line(points: [newPoint], color: selectedColor, width: selectedWidth)
                    } else {
                        currentLine.points.append(newPoint)
                    }
                }
                .onEnded { _ in
                    if !currentLine.points.isEmpty {
                        lines.append(currentLine)
                    }
                    currentLine = Line(points: [], color: selectedColor, width: selectedWidth)
                }
            )
        }
    }
} 