import SwiftUI

struct BallonSketchView: View {
    @StateObject var ballonSketchModel =  BallonSketchViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var grids = [GridItem(.flexible(), spacing: -20),
                        GridItem(.flexible(), spacing: -20),
                        GridItem(.flexible(), spacing: -20)]
    
    
    @State var thoughts = ["1", "2", "3", "4", "5", "6"]
    @State var chosenThoughts = Array(repeating: "", count: 6)
    
    @State private var showChooseScreen = false
    @State var sketchImage: Data? = nil
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 233/255, green: 225/255, blue: 46/255, alpha: 1)
        appearance.shadowColor = .clear
        
        if let customFont = UIFont(name: "Quicksand-Bold", size: 20) {
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: customFont
            ]
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: customFont.withSize(34)
            ]
        } else {
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(.bg)
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
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
                                            ballonSketchModel.selectedColor = sketchColor
                                        }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical)
                        }
                        .padding(.top, 20)
                        
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
                                selectedColor: ballonSketchModel.selectedColor.color,
                                selectedWidth: ballonSketchModel.selectedBrush.width
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .frame(height: 472)
                            .padding(.horizontal)
                        }
                        
                        HStack(spacing: 12) {
                            ForEach(Array(ballonSketchModel.brushes.enumerated()), id: \.element.id) { index, brush in
                                Image(brush.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 48, height: 160)
                                    .foregroundColor(.black)
                                    .shadow(color: Color(red: 232/255, green: 226/255, blue: 44/255), radius:  ballonSketchModel.selectedBrush == brush ? 8 : 0)
                                    .offset(y: CGFloat(index) * 20)
                                    .onTapGesture {
                                        ballonSketchModel.selectedBrush = brush
                                            
                                    }
                                    .animation(.spring(), value: ballonSketchModel.selectedBrush)
                            }
                            
                            Button(action: {
                                let size = CGSize(width: UIScreen.main.bounds.width - 32, height: 472)
                                let image = CanvasView(
                                    lines: $ballonSketchModel.lines,
                                    selectedColor: ballonSketchModel.selectedColor.color,
                                    selectedWidth: ballonSketchModel.selectedBrush.width
                                ).asImage(size: size)
                                print("snapshot image size: \(image.size)")
                                if let data = image.pngData(), data.count > 0 {
                                    print("PNG data size: \(data.count)")
                                    sketchImage = data
                                    print("sketchImage set, showChooseScreen = true")
                                    showChooseScreen = true
                                    print("Передаём в BallonChooseSketchView: sketchImage = \(sketchImage?.count ?? 0)")
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
                        .padding(.top, 8)
                        .padding(.leading)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Sketch")
        }
        .fullScreenCover(isPresented: $showChooseScreen) {
            BallonChooseSketchView(sketchImageData: sketchImage!)
        }
    }
}

#Preview {
    BallonSketchView()
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
