import SwiftUI

struct BallonMyBallonsView: View {
    @StateObject var ballonMyBallonsModel = BallonMyBallonsViewModel()
    
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
                        ForEach(ballonMyBallonsModel.cards) { card in
                            SwipeToDeleteCard(card: card) {
                                withAnimation {
                                    ballonMyBallonsModel.delete(card: card)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("My ballons")
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
                        .frame(width: 42, height: 62)
                 
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
                                        BallonGraphView(ballons: BallonGraphView.zigzagNodes)
                                    }
                                }
                                .frame(height: 170)
                                .cornerRadius(20)
                                .padding(.horizontal, 10)
                            
                            Text("Name")
                                .Sand(size: 12)
                        }
                    }
            )
            .frame(height: 220)
            .cornerRadius(20)
            .padding(.horizontal)
    }
}

extension BallonGraphView {
    static var zigzagNodes: [BallonNode] {
        [
            BallonNode(id: 0, imageName: "ball1", text: "texttext\ntexttext", position: CGPoint(x: 50, y: 120), connections: [1]),
            BallonNode(id: 1, imageName: "ball2", text: "texttext\ntexttext", position: CGPoint(x: 100, y: 40), connections: [2]),
            BallonNode(id: 2, imageName: "ball3", text: "texttext\ntexttext", position: CGPoint(x: 170, y: 120), connections: [3]),
            BallonNode(id: 3, imageName: "ball4", text: "texttext\ntexttext", position: CGPoint(x: 220, y: 40), connections: [4]),
            BallonNode(id: 4, imageName: "ball5", text: "texttext\ntexttext", position: CGPoint(x: 290, y: 120), connections: [5]),
            BallonNode(id: 5, imageName: "ball6", text: "texttext\ntexttext", position: CGPoint(x: 340, y: 40), connections: [])
        ]
    }
}

#Preview {
    BallonMyBallonsView()
}

