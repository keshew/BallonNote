import SwiftUI

struct BallonSketchView: View {
    @StateObject var ballonSketchModel =  BallonSketchViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var grids = [GridItem(.flexible(), spacing: -20),
                        GridItem(.flexible(), spacing: -20),
                        GridItem(.flexible(), spacing: -20)]
    
    @State private var showChooseScreen = false
    @State var sketchImage: Data? = nil
    @State private var currentLine: Line = Line(points: [], color: .black, width: 2)
    
    var body: some View {
        ZStack {
            Image(.bg)
                .resizable()
                .ignoresSafeArea()
            
            Color(red: 233/255, green: 225/255, blue: 46/255)
                .frame(height: 170)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / -35)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 35, height: 35)
                                .overlay(
                                    Circle()
                                        .stroke(Color.orange, lineWidth: 1)
                                        .overlay {
                                            VStack {
                                                Image(.backButton)
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .offset(x: -1)
                                                
                                                Text("Back")
                                                    .Sand(size: 6)
                                            }
                                        }
                                )
                        }
                        
                        Spacer()
                        
                        Text("Sketch")
                            .SandBold(size: 20)
                            .padding(.trailing, 35)
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.horizontal)
                    
                    colorPalette
                    sketchCanvas
                    
                    HStack(spacing: 12) {
                        BrushPicker(
                            selectedBrush: $ballonSketchModel.selectedBrush,
                            brushes: ballonSketchModel.brushes,
                            onBrushSelect: { brush in
                                finishCurrentLineIfNeeded()
                                currentLine = Line(points: [], color: ballonSketchModel.selectedColor.color, width: brush.width)
                                ballonSketchModel.selectedBrush = brush
                            }
                        )
                        
                        Button(action: {
                            let size = CGSize(width: UIScreen.main.bounds.width - 32, height: 472)
                            let image = CanvasView(
                                lines: $ballonSketchModel.lines,
                                currentLine: $currentLine,
                                getCurrentColor: { ballonSketchModel.selectedColor.color },
                                getCurrentWidth: { ballonSketchModel.selectedBrush.width }
                            ).asImage(size: size)
                            
                            if let data = image.pngData(), data.count > 0 {
                                sketchImage = data
                                showChooseScreen = true
                                ballonSketchModel.agaon = 0
                            } else {
                                print("snapshot error")
                            }
                        }) {
                            Rectangle()
                                .fill(Color(red: 232/255, green: 226/255, blue: 44/255))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 248/255, green: 167/255, blue: 54/255), lineWidth: 2)
                                        .overlay {
                                            Text("Add")
                                                .SandBold(size: 14)
                                        }
                                }
                                .frame(height: 48)
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 15)
                    .padding(.leading)
                }
            }
        }
        .fullScreenCover(isPresented: $showChooseScreen) {
            BallonChooseSketchView(sketchImageData: sketchImage!)
        }
    }
    
    private func finishCurrentLineIfNeeded() {
        if !currentLine.points.isEmpty {
            ballonSketchModel.lines.append(currentLine)
            currentLine = Line(points: [], color: ballonSketchModel.selectedColor.color, width: ballonSketchModel.selectedBrush.width)
        }
    }
    
    private var colorPalette: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(ballonSketchModel.colors) { sketchColor in
                    Circle()
                        .fill(sketchColor.color)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(ballonSketchModel.selectedColor == sketchColor ? 0.7 : 0), lineWidth: 1)
                        )
                        .scaleEffect(ballonSketchModel.selectedColor == sketchColor ? 1.15 : 1.0)
                        .onTapGesture {
                            onColorSelect(sketchColor)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .padding(.top, 20)
    }
    
    private func onColorSelect(_ sketchColor: SketchColor) {
        finishCurrentLineIfNeeded()
        currentLine = Line(points: [], color: sketchColor.color, width: ballonSketchModel.selectedBrush.width)
        ballonSketchModel.selectedColor = sketchColor
    }
    
    private var sketchCanvas: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 247/255, green: 245/255, blue: 233/255))
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.gray.opacity(0.3))
                }
                .frame(height: 472)
                .padding(.horizontal)
            CanvasView(
                lines: $ballonSketchModel.lines,
                currentLine: $currentLine,
                getCurrentColor: { ballonSketchModel.selectedColor.color },
                getCurrentWidth: { ballonSketchModel.selectedBrush.width }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .frame(height: 472)
            .padding(.horizontal)
        }
    }
}

#Preview {
    BallonSketchView()
}

struct CanvasView: View {
    @Binding var lines: [Line]
    @Binding var currentLine: Line
    var getCurrentColor: () -> Color
    var getCurrentWidth: () -> CGFloat
    
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
                        currentLine = Line(points: [newPoint], color: getCurrentColor(), width: getCurrentWidth())
                    } else {
                        currentLine.points.append(newPoint)
                    }
                }
                .onEnded { _ in
                    finishCurrentLineIfNeeded()
                }
            )
        }
    }
    
    private func finishCurrentLineIfNeeded() {
        if !currentLine.points.isEmpty {
            lines.append(currentLine)
            currentLine = Line(points: [], color: getCurrentColor(), width: getCurrentWidth())
        }
    }
}

extension View {
    func asImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view!
        view.bounds = CGRect(origin: .zero, size: size)
        view.backgroundColor = .clear
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}

struct BrushPicker: View {
    @Binding var selectedBrush: Brush
    var brushes: [Brush]
    var onBrushSelect: (Brush) -> Void
    
    var body: some View {
        ForEach(Array(brushes.enumerated()), id: \.element.id) { index, brush in
            Image(brush.icon)
                .resizable()
//                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width > 900 ? 96 : UIScreen.main.bounds.width > 600 ? 68 : 48, height: UIScreen.main.bounds.width > 900 ? 720 : UIScreen.main.bounds.width > 600 ? 560 : 260)
                .foregroundColor(.black)
                .shadow(color: Color(red: 232/255, green: 226/255, blue: 44/255), radius: selectedBrush == brush ? 8 : 0)
                .offset(y: CGFloat(index) * 20)
                .onTapGesture {
                    onBrushSelect(brush)
                }
                .animation(.spring(), value: selectedBrush)
        }
    }
}
