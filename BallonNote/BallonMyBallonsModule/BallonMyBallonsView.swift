import SwiftUI

struct BallonMyBallonsView: View {
    @StateObject var ballonMyBallonsModel = BallonMyBallonsViewModel()
    
   
    
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
                        Text("Ballons")
                            .SandBold(size: 20)
                    }
                    .padding(.top, 5)
                    .padding(.horizontal)
                    
                    ForEach(ballonMyBallonsModel.cards) { card in
                        SwipeToDeleteCard(card: card) {
                            withAnimation {
                                ballonMyBallonsModel.delete(card: card, login: UserDefaultsManager().getEmail() ?? "йцуйцу")
                            }
                        } onTap: {
//                            ballonMyBallonsModel.isDetail = true
                        }
                    }
                    .padding(.top)
                    
                    Color.clear.frame(height: 80)
                }
                .padding(.top)
            }
        }
//        .fullScreenCover(isPresented: $ballonMyBallonsModel.isDetail) {
//            BallonDetailBallonView()
//        }
        .onAppear {
            ballonMyBallonsModel.fetchCards(login: UserDefaultsManager().getEmail() ?? "йцуйцу")
          }
    }
}

struct BallonNode: Identifiable {
    let id: Int
    let imageName: String
    let text: String
    let position: CGPoint
    let connections: [Int]
}

struct BallonGraphView: View {
    let ballons: [BallonNode]
    var body: some View {
        ZStack {
            Canvas { context, size in
                for ballon in ballons {
                    for connection in ballon.connections {
                        if let to = ballons.first(where: { $0.id == connection }) {
                            let fromPoint = ballon.position
                            let toPoint = to.position
                            var path = Path()
                            path.move(to: fromPoint)
                            path.addLine(to: toPoint)
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
                            Text(ballon.text)
                                .Sand(size: 8)
                                .offset(y: -7)
                        }
                        .frame(width: 37, height: 57)
                 
                }
                .position(ballon.position)
            }
        }
        .frame(height: 154)
    }
}

struct SwipeToDeleteCard: View {
    let card: BallonCard
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
                                        BallonGraphView(ballons: BallonGraphView.nodes(from: card.ballons))
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

extension BallonGraphView {
    static func nodes(from ballons: [String]) -> [BallonNode] {
        let filteredBallons = ballons.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        let positions: [CGPoint] = [
            CGPoint(x: 40, y: 120),
            CGPoint(x: 90, y: 40),
            CGPoint(x: 150, y: 120),
            CGPoint(x: 200, y: 40),
            CGPoint(x: 260, y: 120),
            CGPoint(x: 310, y: 40)
        ]
        
        let connections: [[Int]] = [
            [1],
            [2],
            [3],
            [4],
            [5],
            []
        ]
        
        let count = filteredBallons.count
        var nodes: [BallonNode] = []
        
        for index in 0..<count {
            let node = BallonNode(
                id: index,
                imageName: "ball\(index + 1)",
                text: filteredBallons[index],
                position: positions[index],
                connections: connections[index].filter { $0 < count }
            )
            nodes.append(node)
        }
        
        return nodes
    }
}

#Preview {
    BallonMyBallonsView()
}

