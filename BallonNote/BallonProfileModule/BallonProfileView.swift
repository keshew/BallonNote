import SwiftUI

struct BallonProfileView: View {
    @StateObject var ballonProfileModel =  BallonProfileViewModel()
    
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
                                        VStack(spacing: 40) {
                                            VStack(spacing: 15) {
                                                Text("JAMES SMITH")
                                                    .Sand(size: 20)
                                                
                                                Text("james.smithmail.gg")
                                                    .Sand(size: 16)
                                            }
                                            
                                            VStack(spacing: 20) {
                                                HStack {
                                                    Image(systemName: "envelope.fill")
                                                    
                                                    Text("Email Notifications")
                                                        .Sand(size: 12)
                                                    
                                                    Toggle("", isOn: $ballonProfileModel.isNotif)
                                                        .toggleStyle(CustomToggleStyle())
                                                }
                                                .padding(.horizontal)
                                                
                                                HStack {
                                                    Image(systemName: "bell.fill")
                                                        .padding(.leading, 5)
                                                    
                                                    Text("Push Notifications")
                                                        .Sand(size: 12)
                                                    
                                                    Toggle("", isOn: $ballonProfileModel.isEmail)
                                                        .toggleStyle(CustomToggleStyle())
                                                }
                                                .padding(.horizontal)
                                            }
                                            
                                            VStack(spacing: 20) {
                                                Button(action: {
                                                    
                                                }) {
                                                    Image(.changeName)
                                                        .resizable()
                                                        .frame(width: 177, height: 47)
                                                }
                                                
                                                Button(action: {
                                                    
                                                }) {
                                                    Image(.changeMail)
                                                        .resizable()
                                                        .frame(width: 177, height: 47)
                                                }
                                                
                                                Button(action: {
                                                    
                                                }) {
                                                    Image(.logOut)
                                                        .resizable()
                                                        .frame(width: 177, height: 47)
                                                }
                                                
                                                Button(action: {
                                                    
                                                }) {
                                                    Image(.deleteAcc)
                                                        .resizable()
                                                        .frame(width: 177, height: 47)
                                                }
                                            }
                                        }
                                    }
                            }
                            .frame(height: 500)
                            .cornerRadius(24)
                            .padding(.horizontal, 40)
                            .padding(.top, 100)
                    }
                }
                .scrollDisabled(UIScreen.main.bounds.width > 380  ? true : false)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    BallonProfileView()
}


