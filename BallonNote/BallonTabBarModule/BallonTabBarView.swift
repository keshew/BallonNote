import SwiftUI

struct BallonTabBarView: View {
    @StateObject var BallonTabBarModel =  BallonTabBarViewModel()
    @State private var selectedTab: CustomTabBar.TabType = .Inspire

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if selectedTab == .Inspire {
                    BallonInspireView()
                } else if selectedTab == .Ballons {
                } else if selectedTab == .Sketch {
                    BallonSketchView()
                } else if selectedTab == .Profile {
                    BallonProfileView()
                }
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BallonTabBarView()
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabType
    
    enum TabType: Int {
        case Inspire
        case Ballons
        case Sketch
        case Profile
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Rectangle()
                    .fill(Color(red: 233/255, green: 225/255, blue: 46/255))
                    .frame(height: 110)
                    .edgesIgnoringSafeArea(.bottom)
                    .offset(y: 35)
            }
            
            HStack(spacing: -70) {
                TabBarItem(imageName: "tab1", tab: .Inspire, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab2", tab: .Ballons, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab3", tab: .Sketch, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab4", tab: .Profile, selectedTab: $selectedTab)
            }
            .padding(.top, 10)
            .frame(height: 60)
        }
    }
}

struct TabBarItem: View {
    let imageName: String
    let tab: CustomTabBar.TabType
    @Binding var selectedTab: CustomTabBar.TabType
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 12) {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 58, height: 58)
                    .cornerRadius(29)
                    .overlay {
                        VStack {
                            Image(imageName)
                                .resizable()
                                .frame(
                                    width: 20,
                                    height: 22
                                )
                                .opacity(selectedTab == tab ? 1 : 0.4)
                            
                            Text("\(tab)")
                                .Sand(
                                    size: 7,
                                    color: selectedTab == tab
                                    ? Color(red: 235/255, green: 142/255, blue: 253/255)
                                    : Color(red: 177/255, green: 160/255, blue: 177/255)
                                )
                        }
                    }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
