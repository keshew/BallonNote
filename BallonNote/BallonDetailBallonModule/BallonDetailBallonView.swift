import SwiftUI

struct BallonDetailBallonView: View {
    @StateObject var ballonDetailBallonModel =  BallonDetailBallonViewModel()
    @Environment(\.presentationMode) var presentationMode
    
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
                    VStack {
                        Rectangle()
                            .fill(Color(red: 247/255, green: 245/255, blue: 233/255))
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.gray.opacity(0.3), lineWidth: 2)
                                    .overlay {
                                        VStack(spacing: 15) {
                                            Text("Name of inspire")
                                                .Sand(size: 12)
                                        }
                                    }
                            }
                            .frame(height: 95)
                            .cornerRadius(24)
                            .padding(.horizontal, 40)
                            .padding(.top, 20)
                        
                        
                        Button(action: {
                            
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
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Details")
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
}

#Preview {
    BallonDetailBallonView()
}

