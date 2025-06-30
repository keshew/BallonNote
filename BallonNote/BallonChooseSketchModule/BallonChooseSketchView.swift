import SwiftUI

struct BallonChooseSketchView: View {
    var sketchImageData: Data?
    @StateObject var ballonChooseSketchModel =  BallonChooseSketchViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var grids = [GridItem(.flexible(), spacing: -20),
                        GridItem(.flexible(), spacing: -20),
                        GridItem(.flexible(), spacing: -20)]
    
    @State var thoughts = ["1", "2", "3", "4", "5", "6"]
    @State var chosenThoughts = Array(repeating: "", count: 6)
    
//    init(sketchImageData: Data) {
//        self.sketchImageData = sketchImageData
//        print(sketchImageData)
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
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(.bg)
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Text("Your ballons")
                            .SandBold(size: 14)
                            .padding(.top)
                        
                        LazyVGrid(columns: grids, spacing: 15) {
                            ForEach(0..<6, id: \.self) { index in
                                Rectangle()
                                    .fill(Color(red: 247/255, green: 245/255, blue: 233/255))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.gray.opacity(0.3), lineWidth: 2)
                                            .overlay(
                                                VStack {
                                                    Rectangle()
                                                        .fill(.white)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 16)
                                                                .stroke(.gray.opacity(0.3))
                                                                .overlay(
                                                                    Image("ball\(index + 1)")
                                                                        .resizable()
                                                                        .frame(width: 23, height: 33)
                                                                )
                                                        )
                                                        .frame(width: 58, height: 58)
                                                        .cornerRadius(16)
                                                    
                                                    Rectangle()
                                                        .fill(.white)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 16)
                                                                .stroke(.gray.opacity(0.3))
                                                                .overlay(
                                                                    Text(chosenThoughts[index])
                                                                        .Sand(size: 10)
                                                                )
                                                        )
                                                        .frame(height: 45)
                                                        .cornerRadius(16)
                                                        .padding(.horizontal, 15)
                                                }
                                            )
                                    )
                                    .frame(width: 126, height: 126)
                                    .cornerRadius(24)
                            }
                        }
                        .padding(.top)
                        
                        Text("Your thoughts")
                            .SandBold(size: 14)
                            .padding(.top)
                        
                        CustomTextFiled2(text: $ballonChooseSketchModel.nameOfInspire, placeholder: "Enter here name of Inspire")
                        
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 247/255, green: 245/255, blue: 233/255))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.3))
                                        .overlay {
                                            if let data = sketchImageData, let image = UIImage(data: data) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame( height: 192)
                                                    .cornerRadius(12)
                                                    .padding(.horizontal, 35)
                                            }
                                        }
                                )
                                .cornerRadius(16)
                                .frame(height: 192)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {}) {
                            Rectangle()
                                .fill(Color(red: 232/255, green: 226/255, blue: 44/255))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 248/255, green: 167/255, blue: 54/255), lineWidth: 2)
                                        .overlay(
                                            Text("Create \(sketchImageData)")
                                                .SandBold(size: 14)
                                        )
                                )
                                .frame(height: 48)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 40)
                    }
                }
                .scrollDisabled(UIScreen.main.bounds.width > 380  ? true : false)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Choose ballons")  .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
                }
            }
        }
    }
    
    func moveThoughtToChosen(_ thought: String) {
        if let idx = chosenThoughts.firstIndex(where: { $0.isEmpty }) {
            chosenThoughts[idx] = thought
            if let removeIdx = thoughts.firstIndex(of: thought) {
                thoughts.remove(at: removeIdx)
            }
        }
    }
}

#Preview {
    BallonChooseSketchView(sketchImageData: Data())
}

