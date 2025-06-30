import SwiftUI

struct BallonOnboardingView: View {
    @StateObject var ballonOnboardingModel =  BallonOnboardingViewModel()
    
    var body: some View {
        ZStack {
            Image(.bg)
                .resizable()
                .ignoresSafeArea()
            
            Image(ballonOnboardingModel.contact.arrayOfImage[ballonOnboardingModel.currentIndex])
                .resizable()
                .frame(width: 312, height: 468)
                .position(ballonOnboardingModel.currentIndex % 2 == 0 ? CGPoint(x: UIScreen.main.bounds.width / 2.9, y: UIScreen.main.bounds.height / 1.445) : CGPoint(x: UIScreen.main.bounds.width / 1.6, y: UIScreen.main.bounds.height / 1.445))
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 80) {
                    Rectangle()
                        .fill(ballonOnboardingModel.contact.arrayOfColors[ballonOnboardingModel.currentIndex])
                        .overlay {
                            Text(ballonOnboardingModel.contact.arrayOfTitleText[ballonOnboardingModel.currentIndex])
                                .SandBold(size: 18)
                        }
                        .frame(height: 75)
                        .cornerRadius(77)
                        .padding(.horizontal, 90)
                    
                    Image(ballonOnboardingModel.currentIndex % 2 == 0 ? .bubble1 : .bubble2)
                        .resizable()
                        .overlay {
                            Text(ballonOnboardingModel.contact.arrayOfBubbleText[ballonOnboardingModel.currentIndex])
                                .SandBold(size: 20)
                                .multilineTextAlignment(.center)
                                .padding()
                                .offset(y: -30)
                        }
                        .frame(height: 284)
                        .padding(.horizontal, 50)
                    
                    HStack {
                        if ballonOnboardingModel.currentIndex % 2 == 0 {
                            Spacer()
                        }
                  
                        
                        Rectangle()
                            .fill(ballonOnboardingModel.contact.arrayOfColors[ballonOnboardingModel.currentIndex])
                            .overlay {
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 6
                                    )
                                    .overlay {
                                        Text("Next")
                                            .SandBold(size: 25)
                                    }
                            }
                            .frame(width: 169, height: 60)
                            .cornerRadius(30)
                            .padding(.trailing, 30)
                            .padding(.leading, 30)
                            .padding(.top, 120)
                            .onTapGesture {
                                if ballonOnboardingModel.currentIndex <= 2 {
                                    withAnimation {
                                        ballonOnboardingModel.currentIndex += 1
                                    }
                                } else {
                                    
                                }
                            }
                        
                        if ballonOnboardingModel.currentIndex % 2 != 0 {
                            Spacer()
                        }
                    }
                    
                    
                }
                .padding(.top, 90)
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380  ? true : false)
        }
    }
}

#Preview {
    BallonOnboardingView()
}

