import SwiftUI

struct BallonSignView: View {
    @StateObject var ballonSignModel =  BallonSignViewModel()

    var body: some View {
        ZStack {
            Image(.bg)
                .resizable()
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Rectangle()
                        .fill(.white.opacity(0.6))
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.white, lineWidth: 2)
                                .overlay {
                                    VStack(spacing: 25) {
                                        Image(.ballons)
                                            .resizable()
                                            .frame(width: 41, height: 48)
                                        
                                        Text("Register")
                                            .SandBold(size: 32)
                                        
                                        Text("Enter your name, email and password to register")
                                            .Sand(size: 12)
                                        
                                        VStack {
                                            CustomTextFiled(text: $ballonSignModel.email, placeholder: "Enter your email")
                                            
                                            CustomTextFiled(text: $ballonSignModel.name, placeholder: "Enter your name")
                                            
                                            CustomSecureField(text: $ballonSignModel.password, placeholder: "Enter your password")
                                        }
                                        
                                        VStack(spacing: 20) {
                                            Button(action: {
                                                
                                            }) {
                                                Rectangle()
                                                    .fill(Color(red: 233/255, green: 227/255, blue: 50/255))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(Color(red: 250/255, green: 168/255, blue: 55/255), lineWidth: 2)
                                                            .overlay {
                                                                Text("Register")
                                                                    .SandBold(size: 14)
                                                            }
                                                    }
                                                    .frame(height: 48)
                                                    .cornerRadius(16)
                                                    .padding(.horizontal)
                                            }
                                            
                                            Button(action: {
                                                
                                            }) {
                                                Rectangle()
                                                    .fill(Color(red: 233/255, green: 227/255, blue: 50/255))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(Color(red: 250/255, green: 168/255, blue: 55/255), lineWidth: 2)
                                                            .overlay {
                                                                Text("Log In as guest")
                                                                    .SandBold(size: 14)
                                                            }
                                                    }
                                                    .frame(height: 48)
                                                    .cornerRadius(16)
                                                    .padding(.horizontal)
                                            }
                                            
                                            HStack {
                                                Text("Do you have an account?")
                                                    .SandBold(size: 12, color: Color(red: 108/255, green: 114/255, blue: 119/255))
                                                
                                                Button(action: {
                                                    
                                                }) {
                                                    Text("Log in")
                                                        .SandBold(size: 12, color: Color(red: 230/255, green: 230/255, blue: 77/255))
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                        .frame(height: 540)
                        .cornerRadius(24)
                        .padding(.horizontal, 40)
                        .padding(.top, 150)
                }
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380  ? true : false)
        }
    }
}

#Preview {
    BallonSignView()
}

