import SwiftUI

struct BallonChooseView: View {
    @StateObject var ballonChooseModel = BallonChooseViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var grids = [GridItem(.flexible(), spacing: -20),
                        GridItem(.flexible(), spacing: -20),
                        GridItem(.flexible(), spacing: -20)]
    
    @State var thoughts = ["1", "2", "3", "4", "5", "6"]
    @State var chosenThoughts = Array(repeating: "", count: 6)
    @Binding var chosenName: String
    @Binding var getThoughts: [String]
    @State var isGood = false
  
    
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
                            .padding(.trailing, 30)
                        
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
                                                                    .frame(width: 31, height: 45)
                                                            )
                                                    )
                                                    .frame(width: 79, height: 79)
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
                                                    .frame(height: 26)
                                                    .cornerRadius(12)
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
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color(red: 247/255, green: 245/255, blue: 233/255))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.3))
                            )
                            .cornerRadius(16)
                            .frame(height: 192)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        LazyVGrid(columns: grids, spacing: 15) {
                            ForEach(Array(getThoughts.enumerated()), id: \.element) { (index, thought) in
                                Rectangle()
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.3))
                                            .overlay(
                                                Text(thought)
                                                    .Sand(size: 10)
                                            )
                                    )
                                    .cornerRadius(16)
                                    .frame(height: 26)
                                    .padding(.horizontal, 15)
                                    .onTapGesture {
                                        moveThoughtToChosen(thought)
                                    }
                            }
                        }
                        .padding(.top, 30)
                        .padding(.horizontal)
                    }
                    
                    Button(action: {
                        ballonChooseModel.saveInspire(
                                login: UserDefaultsManager().getEmail() ?? "",
                              name: chosenName,
                              thoughts: chosenThoughts
                          ) { result in
                              switch result {
                              case .success(let message):
                                  print("Success: \(message)")
                                  isGood = true
                              case .failure(let error):
                                  print("Error: \(error.localizedDescription)")
                              }
                          }
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
        .fullScreenCover(isPresented: $isGood) {
            BallonTabBarView()
        }
    }
    
    func moveThoughtToChosen(_ thought: String) {
        if let idx = chosenThoughts.firstIndex(where: { $0.isEmpty }) {
            chosenThoughts[idx] = thought
            if let removeIdx = getThoughts.firstIndex(of: thought) {
                getThoughts.remove(at: removeIdx)
            }
        }
    }
}

#Preview {
    BallonChooseView(chosenName: .constant(""), getThoughts: .constant(["123"]))
}

