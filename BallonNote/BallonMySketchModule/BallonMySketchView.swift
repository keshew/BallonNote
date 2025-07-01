import SwiftUI

struct BallonMySketchView: View {
    @StateObject var ballonMySketchModel =  BallonMySketchViewModel()
    @State var isAdd = false
    func setupNavigationBarAppearance() {
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
                        ForEach(ballonMySketchModel.cards) { card in
                            SwipeToDeleteCard2(card: card) {
                                withAnimation {
                                    ballonMySketchModel.delete(card: card)
                                }
                            } onTap: {
                                ballonMySketchModel.isDetail = true
                            }
                        }
                        
                        Color.clear.frame(height: 80)
                    }
                    .padding(.top)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("My sketches")
            .navigationTitle("Choose ballons")  .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAdd = true
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 35, height: 35)
                            .overlay(
                                Circle()
                                    .stroke(Color.orange, lineWidth: 1)
                                    .overlay {
                                        VStack {
                                            Image(systemName: "plus")
                                                .font(.system(size: 14,weight: .semibold))
                                                .foregroundStyle(.black)

                                            Text("Add")
                                                .Sand(size: 6)
                                        }
                                    }
                            )
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $ballonMySketchModel.isDetail) {
            BallonDetailBallonView()
        }
        .fullScreenCover(isPresented: $isAdd) {
            BallonSketchView()
        }
        .onAppear {
            setupNavigationBarAppearance()
            ballonMySketchModel.fetchCards(login: "йцуйцу")
          }
    }
}

#Preview {
    BallonMySketchView()
}

struct BallonCard2: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let ballons: [Data?]  // Массив данных изображений для шариков
}

struct BallonNode2: Identifiable {
    let id: Int
    let imageName: String
    let imageData: Data?   // Данные изображения для отображения
    let position: CGPoint
    let connections: [Int]
}

struct SwipeToDeleteCard2: View {
    let card: BallonCard2
    var onDelete: () -> Void
    var onTap: () -> Void
    @State private var offset: CGFloat = 0
    @State private var showDelete: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            if showDelete {
                HStack {
                    Button(action: onDelete) {
                        Image(.delete)
                            .resizable()
                            .frame(width: 70, height: 70)
                    }
                    .padding(.leading)
                    Spacer()
                }
            }
            cardView
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width > 0 {
                                offset = min(value.translation.width, 80)
                            }
                        }
                        .onEnded { value in
                            if value.translation.width > 60 {
                                withAnimation {
                                    showDelete = true
                                    offset = 80
                                }
                            } else {
                                withAnimation {
                                    showDelete = false
                                    offset = 0
                                }
                            }
                        }
                )
                .onTapGesture {
                    onTap()
                }
        }
        .animation(.spring(), value: offset)
    }
    
    var cardView: some View {
        Rectangle()
            .fill(Color(red: 247/255, green: 245/255, blue: 233/255))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .overlay {
                        VStack(spacing: 10) {
                            Rectangle()
                                .fill(.white)
                                .overlay {
                                    VStack(spacing: 10) {
                                        BallonGraphView2(ballons: BallonGraphView2.nodes(from: card.ballons))
                                    }
                                }
                                .frame(height: 170)
                                .cornerRadius(20)
                                .padding(.horizontal, 10)
                            
                            Text(card.name)
                                .Sand(size: 12)
                        }
                    }
            )
            .frame(height: 220)
            .cornerRadius(20)
            .padding(.horizontal, 35)
    }
}

struct BallonGraphView2: View {
    let ballons: [BallonNode2]
    var body: some View {
        ZStack {
            Canvas { context, size in
                for ballon in ballons {
                    for connection in ballon.connections {
                        if let to = ballons.first(where: { $0.id == connection }) {
                            var path = Path()
                            path.move(to: ballon.position)
                            path.addLine(to: to.position)
                            context.stroke(path, with: .color(.black), lineWidth: 2)
                        }
                    }
                }
            }
            ForEach(ballons) { ballon in
                VStack(spacing: 0) {
                    Image(ballon.imageName)
                        .resizable()
                        .overlay {
                            if let data = ballon.imageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .offset(y: -7)
                            } else {
                                Text("No Img")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .offset(y: -7)
                            }
                        }
                        .frame(width: 37, height: 57)
                }
                .position(ballon.position)
            }
        }
        .frame(height: 154)
    }
}

extension BallonGraphView2 {
    static func nodes(from images: [Data?]) -> [BallonNode2] {
        let positions: [CGPoint] = [
            CGPoint(x: 40, y: 120),
            CGPoint(x: 90, y: 40),
            CGPoint(x: 150, y: 120),
            CGPoint(x: 200, y: 40),
            CGPoint(x: 260, y: 120),
            CGPoint(x: 310, y: 40)
        ]
        let connections: [[Int]] = [
            [1], [2], [3], [4], [5], []
        ]
        let count = min(images.count, positions.count)
        var nodes: [BallonNode2] = []
        for index in 0..<count {
            nodes.append(BallonNode2(
                id: index,
                imageName: "ball\(index + 1)",
                imageData: images[index],
                position: positions[index],
                connections: connections[index].filter { $0 < count }
            ))
        }
        return nodes
    }
}
