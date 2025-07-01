//import SwiftUI
//
//struct BallonDetailBallonView: View {
//    @StateObject var viewModel = BallonDetailBallonViewModel()
//    @Environment(\.presentationMode) var presentationMode
//    
//    init() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(red: 233/255, green: 225/255, blue: 46/255, alpha: 1)
//        appearance.shadowColor = .clear
//        
//        if let customFont = UIFont(name: "Quicksand-Bold", size: 20) {
//            appearance.titleTextAttributes = [
//                .foregroundColor: UIColor.black,
//                .font: customFont
//            ]
//            appearance.largeTitleTextAttributes = [
//                .foregroundColor: UIColor.black,
//                .font: customFont.withSize(34)
//            ]
//        } else {
//            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
//        }
//        
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance
//        UINavigationBar.appearance().tintColor = .white
//    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Image(.bg)
//                    .resizable()
//                    .ignoresSafeArea()
//                
//                GeometryReader { geo in
//                    ScrollView(showsIndicators: false) {
//                        ZStack {
//                            ForEach(0..<viewModel.balloons.count-1, id: \.self) { i in
//                                let fromLeft = i % 2 == 0
//                                let toLeft = (i+1) % 2 == 0
//                                let y1 = CGFloat(i) * 120 + 80
//                                let y2 = CGFloat(i+1) * 120 + 80
//                                let x1 = fromLeft ? geo.size.width * 0.22 : geo.size.width * 0.78
//                                let x2 = toLeft ? geo.size.width * 0.22 : geo.size.width * 0.78
//                                BalloonLine(from: CGPoint(x: x1, y: y1), to: CGPoint(x: x2, y: y2))
//                            }
//                            
//                            ForEach(Array(viewModel.balloons.enumerated()), id: \.element.id) { i, balloon in
//                                let isLeft = i % 2 == 0
//                                let y = CGFloat(i) * 120 + 80
//                                let x = isLeft ? geo.size.width * 0.22 : geo.size.width * 0.78
//                                ZStack {
//                                    BalloonView(balloon: balloon)
//                                        .onTapGesture {
//                                            withAnimation { viewModel.selectBalloon(balloon) }
//                                        }
//                                        .shadow(radius: 4)
//                                        .opacity(viewModel.selectedBalloonID == balloon.id ? 0.5 : 1)
//                                    
//                                    if viewModel.selectedBalloonID == balloon.id {
//                                        VStack(spacing: 0) {
//                                            Button(action: {
//                                                withAnimation { viewModel.deleteSelectedBalloon() }
//                                            }) {
//                                                Image(.delete)
//                                                    .resizable()
//                                                    .frame(width: 42, height: 42)
//                                            }
//                                            .offset(x: -40, y: -60)
//                                            Spacer().frame(height: 0)
//                                        }
//                                    }
//                                }
//                                .position(x: x, y: y)
//                                .animation(.spring(), value: viewModel.balloons)
//                            }
//                        }
//                        .frame(height: CGFloat(max(geo.size.height, CGFloat(viewModel.balloons.count) * 120 + 100)))
//                    }
//                }
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationTitle("Details")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 35, height: 35)
//                            .overlay(
//                                Circle()
//                                    .stroke(Color.orange, lineWidth: 1)
//                                    .overlay {
//                                        VStack {
//                                            Image(.backButton)
//                                                .resizable()
//                                                .frame(width: 15, height: 15)
//                                                .offset(x: -1)
//                                            Text("Back")
//                                                .Sand(size: 6)
//                                        }
//                                    }
//                            )
//                    }
//                }
//            }
//        }
//    }
//}
//
//private struct BalloonView: View {
//    let balloon: BalloonItem
//    var body: some View {
//        ZStack {
//            Image(.ball1)
//                .resizable()
//                .frame(width: 75, height: 109)
//            
//            Text(balloon.text)
//                .Sand(size: 12)
//                .multilineTextAlignment(.center)
//                .padding(8)
//                .frame(width: 70, height: 65)
//                .offset(y: -13)
//        }
//    }
//}
//
//private struct BalloonLine: View {
//    let from: CGPoint
//    let to: CGPoint
//    var body: some View {
//        Path { path in
//            path.move(to: from)
//            path.addLine(to: to)
//        }
//        .stroke(.black, lineWidth: 2)
//    }
//}
//
//#Preview {
//    BallonDetailBallonView()
//}
//
