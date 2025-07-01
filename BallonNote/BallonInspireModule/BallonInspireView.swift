import SwiftUI

struct BallonInspireView: View {
    @StateObject var ballonInspireModel = BallonInspireViewModel()
    @State private var showAlert = false
    @State var isNext = false
    let maxThoughts = 6
    let thoughtTitles = [
        "First thought",
        "Second thought",
        "Third thought",
        "Fourth thought",
        "Fifth thought",
        "Sixth thought"
    ]
    
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
                        Text("Inspire")
                            .SandBold(size: 20)
                    }
                    .padding(.top, 5)
                    
                    Rectangle()
                        .fill(Color(red: 247/255, green: 245/255, blue: 233/255))
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.gray.opacity(0.3), lineWidth: 2)
                                .overlay {
                                    VStack(spacing: 15) {
                                        Text("Name of inspire")
                                            .Sand(size: 12)
                                        CustomTextFiled2(text: $ballonInspireModel.nameOfInspire, placeholder: "Enter here name of Inspire")
                                    }
                                }
                        }
                        .frame(height: 95)
                        .cornerRadius(24)
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                    
                    VStack(spacing: 25) {
                        ForEach(0..<ballonInspireModel.thoughts.count, id: \.self) { index in
                            ZStack {
                                Rectangle()
                                    .fill(Color(red: 247/255, green: 245/255, blue: 233/255))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(.gray.opacity(0.3), lineWidth: 2)
                                            .overlay {
                                                VStack(spacing: 15) {
                                                    Text(thoughtTitles[index])
                                                        .Sand(size: 12)
                                                    CustomTextView(text: $ballonInspireModel.thoughts[index], placeholder: "Enter your thought")
                                                        .padding(.bottom)
                                                }
                                            }
                                    }
                                    .frame(height: 126)
                                    .cornerRadius(24)
                                    .padding(.horizontal, 40)
                                    .padding(.top)
                            }
                        }
                        
                        if ballonInspireModel.thoughts.count < maxThoughts {
                            Button(action: {
                                if ballonInspireModel.thoughts.count < maxThoughts {
                                    ballonInspireModel.thoughts.append("")
                                } else {
                                    showAlert = true
                                }
                            }) {
                                Image(.addBtn)
                                    .resizable()
                                    .frame(width: 44, height: 42)
                            }
                            .offset(y: -42)
                        }
                    }
                    
                    Button(action: {
                        isNext = true
                    }) {
                        Rectangle()
                            .fill(Color(red: 232/255, green: 226/255, blue: 44/255))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 248/255, green: 167/255, blue: 54/255), lineWidth: 2)
                                    .overlay {
                                        Text("Next")
                                            .SandBold(size: 14)
                                    }
                            }
                            .frame(height: 48)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 40)
                    
                    Color.clear.frame(height: 80)
                }
            }
            .padding(.top, 15)
        }
        .disabled(UserDefaultsManager().isGuest() ? true : false)
        .opacity(UserDefaultsManager().isGuest() ? 0.5 : 1)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Maximum ideas"),
                message: Text("You have added the maximum number of ideas."),
                dismissButton: .default(Text("OK"))
            )
        }
        .fullScreenCover(isPresented: $isNext) {
            BallonChooseView(chosenName: $ballonInspireModel.nameOfInspire, getThoughts: $ballonInspireModel.thoughts)
        }
    }
}

#Preview {
    BallonInspireView()
}

struct CustomTextFiled2: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(.gray.opacity(0.3))
                }
                .frame(height: 47)
                .cornerRadius(22)
                .padding(.horizontal, 15)
            
            TextField("", text: $text, onEditingChanged: { isEditing in
                if !isEditing {
                    isTextFocused = false
                }
            })
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 22)
            .frame(height: 47)
            .font(.custom("Quicksand-Regular", size: 14))
            .cornerRadius(9)
            .foregroundStyle(.black)
            .focused($isTextFocused)
            .padding(.horizontal, 15)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .Sand(size: 14, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                    .frame(height: 47)
                    .padding(.leading, 30)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}

struct CustomTextView: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var height: CGFloat = 60
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(.gray.opacity(0.3))
                }
                .cornerRadius(26)
                .padding(.horizontal)
            
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 15)
                .padding(.horizontal)
                .padding(.top, 5)
                .frame(height: height)
                .font(.custom("Quicksand-Regular", size: 14))
                .focused($isTextFocused)
            
            if text.isEmpty && !isTextFocused {
                VStack {
                    Text(placeholder)
                        .Sand(size: 14, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                        .padding(.leading, 15)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .onTapGesture {
                            isTextFocused = true
                        }
                    Spacer()
                }
            }
        }
        .frame(height: height)
    }
}
