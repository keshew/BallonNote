import SwiftUI

struct BallonMySketchView: View {
    @StateObject var ballonMySketchModel =  BallonMySketchViewModel()
    @State var isAdd = false
    
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
                        Spacer()
                        Text("Sketch")
                            .SandBold(size: 20)
                            .padding(.leading, 50)
                            .padding(.top, 5)
                        
                        Spacer()
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
                        .padding(.trailing)
                    }
                    .padding(.top, -10)
                    .padding(.horizontal)
                    
                    ForEach(ballonMySketchModel.cards) { card in
                        SwipeToDeleteCard2(card: card, onDelete: {
                            withAnimation {
                                ballonMySketchModel.delete(card: card, login: UserDefaultsManager().getEmail() ?? "", sketchId: card.sketchId)
                            }
                        }, onTap: {
//                                ballonMySketchModel.isDetail = true
                        })
                    }
                    .padding(.top)
                    
                    Color.clear.frame(height: 80)
                }
                .padding(.top, 23)
            }
        }
        
//        .fullScreenCover(isPresented: $ballonMySketchModel.isDetail) {
//            BallonDetailBallonView()
//        }
        .fullScreenCover(isPresented: $isAdd) {
            BallonSketchView()
        }
        .onAppear {
            ballonMySketchModel.fetchCards(login: UserDefaultsManager().getEmail() ?? "йцуйцу")
        }
    }
}

#Preview {
    BallonMySketchView()
}

struct BallonCard2: Identifiable, Equatable {
    let sketchId: String
    let name: String
    let ballons: [Data?]
    
    var id: String { sketchId }
}


struct BallonNode2: Identifiable {
    let id: Int
    let imageName: String
    let imageData: Data?
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
