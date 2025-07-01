import SwiftUI

struct BallonProfileView: View {
    @StateObject var ballonProfileModel =  BallonProfileViewModel()
    @State private var showingDeleteAlert = false
       @State private var deleteAccountResult: Result<String, Error>?
    @State var isSign = false
    
    @State private var isEditingName = false
    @State private var newName: String = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    @State private var isEditingEmail = false
    @State private var newEmail: String = ""
    @State private var showEmailErrorAlert = false
    @State private var emailErrorMessage = ""

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
                        Text("Profile")
                            .SandBold(size: 20)
                    }
                    .padding(.top, 20)
                    
                    Rectangle()
                        .fill(Color(red: 247/255, green: 245/255, blue: 233/255))
                        .overlay {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.gray.opacity(0.3), lineWidth: 2)
                                .overlay {
                                    VStack(spacing: 40) {
                                        VStack(spacing: 15) {
                                            Text(UserDefaultsManager().isGuest() ? "Guest" : UserDefaultsManager().getName() ?? "JAMES SMITH")
                                                .Sand(size: 20)
                                            
                                            Text(UserDefaultsManager().isGuest() ? "Guest" : UserDefaultsManager().getEmail() ?? "james.smithmail.gg")
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
                                        
                                        if UserDefaultsManager().isGuest() {
                                            VStack(spacing: 20) {
                                                Button(action: {
                                                    isSign = true
                                                    UserDefaultsManager().saveLoginStatus(false)
                                                    UserDefaultsManager().clearAllUserData()
                                                }) {
                                                    Image(.logOut)
                                                        .resizable()
                                                        .frame(width: 177, height: 47)
                                                }
                                            }
                                        } else {
                                            VStack(spacing: 20) {
                                                if isEditingName {
                                                    VStack(spacing: 10) {
                                                        HStack(spacing: 10) {
                                                            CustomTextFiled(text: $newName, placeholder: "Enter your name")
                                                            
                                                            Button(action: {
                                                                isEditingName = false
                                                                newName = ""
                                                            }) {
                                                                Image(systemName: "delete.backward.fill")
                                                                    .foregroundStyle(.red)
                                                            }
                                                           
                                                            Button(action: {
                                                                changeUsername()
                                                            }) {
                                                                Image(systemName: "checkmark.circle.fill")
                                                                    .foregroundStyle(.green)
                                                            }
                                                            .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                                                            
                                                        }
                                                        .padding(.horizontal)
                                                    }
                                                    .padding(.horizontal)
                                                } else {
                                                    Button(action: {
                                                        isEditingName = true
                                                        newName = ""
                                                    }) {
                                                        Image(.changeName)
                                                            .resizable()
                                                            .frame(width: 177, height: 47)
                                                    }
                                                }
                                                
                                                if isEditingEmail {
                                                    VStack(spacing: 10) {
                                                        HStack(spacing: 10) {
                                                            CustomTextFiled(text: $newEmail, placeholder: "Enter your email")
                                                            
                                                            Button(action: {
                                                                isEditingEmail = false
                                                                newEmail = ""
                                                            }) {
                                                                Image(systemName: "delete.backward.fill")
                                                                    .foregroundStyle(.red)
                                                            }
                                                           
                                                            Button(action: {
                                                                changeEmail()
                                                            }) {
                                                                Image(systemName: "checkmark.circle.fill")
                                                                    .foregroundStyle(.green)
                                                            }
                                                            .disabled(newEmail.trimmingCharacters(in: .whitespaces).isEmpty)
                                                            
                                                        }
                                                        .padding(.horizontal)
                                                    }
                                                    .padding(.horizontal)
                                                  } else {
                                                      Button(action: {
                                                          isEditingEmail = true
                                                          newEmail = ""
                                                      }) {
                                                          Image(.changeMail)
                                                              .resizable()
                                                              .frame(width: 177, height: 47)
                                                      }
                                                  }
                                                
                                                Button(action: {
                                                    if UserDefaultsManager().isGuest() {
                                                        isSign = true
                                                        UserDefaultsManager().quitQuest()
                                                    } else {
                                                        isSign = true
                                                        UserDefaultsManager().saveLoginStatus(false)
                                                        UserDefaultsManager().clearAllUserData()
                                                    }
                                                }) {
                                                    Image(.logOut)
                                                        .resizable()
                                                        .frame(width: 177, height: 47)
                                                }
                                                
                                                Button(action: {
                                                    showingDeleteAlert = true
                                                }) {
                                                    Image(.deleteAcc)
                                                        .resizable()
                                                        .frame(width: 177, height: 47)
                                                }
                                                .alert(isPresented: $showingDeleteAlert) {
                                                    Alert(
                                                        title: Text("Delete Account"),
                                                        message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                                                        primaryButton: .destructive(Text("Delete")) {
                                                            deleteAccount()
                                                        },
                                                        secondaryButton: .cancel()
                                                    )
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                        }
                        .frame(height: UserDefaultsManager().isGuest() ? 300 : 500)
                        .cornerRadius(24)
                        .padding(.horizontal, 40)
                        .padding(.top, 100)
                }
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380  ? true : false)
        }
        .fullScreenCover(isPresented: $isSign) {
            BallonLoginView()
        }
    }
    
    private func changeEmail() {
        guard let login = UserDefaults.standard.string(forKey: "currentEmail") else {
            emailErrorMessage = "You are not auth"
            showEmailErrorAlert = true
            return
        }
        
        ballonProfileModel.changeEmail(login: login, newEmail: newEmail) { result in
            switch result {
            case .success( _):
                UserDefaultsManager().saveCurrentEmail(newEmail)
                isEditingEmail = false
            case .failure(let error):
                emailErrorMessage = error.localizedDescription
                showEmailErrorAlert = true
            }
        }
    }
    
    private func deleteAccount() {
        ballonProfileModel.deleteAccount { result in
            DispatchQueue.main.async {
                deleteAccountResult = result
                
                switch result {
                case .success(let message):
                    print("Аккаунт успешно удалён: \(message)")
                    isSign = true
                    UserDefaultsManager().saveLoginStatus(false)
                    UserDefaultsManager().clearAllUserData()
                case .failure(let error):
                    print("Ошибка удаления аккаунта: \(error.localizedDescription)")
                }
            }
        }
    }

    
    private func changeUsername() {
           guard let login = UserDefaults.standard.string(forKey: "currentEmail") else {
               emailErrorMessage = "You are not auth"
               showErrorAlert = true
               return
           }
           
           ballonProfileModel.changeUsername(login: login, newName: newName) { result in
               switch result {
               case .success( _):
                   UserDefaultsManager().saveName(newName)
                   isEditingName = false
               case .failure(let error):
                   errorMessage = error.localizedDescription
                   showErrorAlert = true
               }
           }
       }
}

#Preview {
    BallonProfileView()
}


