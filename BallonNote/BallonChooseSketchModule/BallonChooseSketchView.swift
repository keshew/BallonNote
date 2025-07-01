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
    @State var selectedBallonIndices: Set<Int> = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var isSaved = false
    
    func saveSketchAction() {
        guard !ballonChooseSketchModel.nameOfInspire.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please, enter name of inspire"
            showAlert = true
            return
        }
        
        guard let data = sketchImageData else {
            alertMessage = "No sketch to save it"
            showAlert = true
            return
        }
        
        let base64String = data.base64EncodedString()
        let sketch = NetworkManager.SketchModel(
            id: UUID().uuidString,
            name: ballonChooseSketchModel.nameOfInspire,
            images: [base64String]
        )
        
        ballonChooseSketchModel.saveSketch(login: UserDefaultsManager().getEmail() ?? "йцуйцу", sketch: sketch) { result in
            switch result {
            case .success(let message):
                print("Сохранено успешно: \(message)")
                isSaved = true
            case .failure(_):
                alertMessage = "Something went wrong"
                showAlert = true
            }
        }
    }

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
                        
                        Text("Choose ballons")
                            .SandBold(size: 20)
                            .padding(.trailing, 40)
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.horizontal)
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
                                                            .overlay {
                                                                if selectedBallonIndices.contains(index), let data = sketchImageData, let image = UIImage(data: data) {
                                                                    Image(uiImage: image)
                                                                        .resizable()
                                                                        .frame(width: 50, height: 50)
                                                                        .cornerRadius(12)
                                                                        .padding(.horizontal, 35)
                                                                }
                                                            }
                                                    )
                                                    .frame(height: 45)
                                                    .cornerRadius(16)
                                                    .padding(.horizontal, 15)
                                            }
                                        )
                                )
                                .frame(width: 126, height: 126)
                                .cornerRadius(24)
                                .onTapGesture {
                                    if selectedBallonIndices.contains(index) {
                                        selectedBallonIndices.remove(index)
                                    } else {
                                        selectedBallonIndices.insert(index)
                                    }
                                }
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
                                                .onTapGesture {
                                                    moveImageToNextBallon()
                                                }
                                        }
                                    }
                            )
                            .cornerRadius(16)
                            .frame(height: 192)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        saveSketchAction()
                    }) {
                        Rectangle()
                            .fill(Color(red: 232/255, green: 226/255, blue: 44/255))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 248/255, green: 167/255, blue: 54/255), lineWidth: 2)
                                    .overlay(
                                        Text("Create")
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
        .fullScreenCover(isPresented: $isSaved, content: {
            BallonTabBarView()
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
    
    func moveImageToNextBallon() {
        let nextIndex = selectedBallonIndices.count % 6
        selectedBallonIndices.insert(nextIndex)
    }
}

#Preview {
    BallonChooseSketchView(sketchImageData: Data())
}

struct SketchModel: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var image: Data
}
