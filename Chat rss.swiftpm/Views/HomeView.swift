import SwiftUI

struct HomeView: View {
    @ObservedObject private var feedViewModel = FeedViewModel()
    @State private var selectedTab: Tab = .feeds
    
    enum Tab {
        case feeds, latestNews, discover, settings
    }
    
    var body: some View {
        NavigationView {
            VStack {
                switch selectedTab {
                case .feeds:
                    FeedListView()
                case .latestNews:
                    LatestNewsView()
                case .discover:
                    Text("发现页面")
                        .font(.largeTitle)
                case .settings:
                    SettingsView()
                }
                Spacer()
                tabBar
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .background(Color(.init(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)))
        }
    }
        
    private var tabBar: some View {
        TabBar(selectedTab: $selectedTab, tabs: [
            .init(title: "订阅列表", imageName: "heart", tag: .feeds),
            .init(title: "最新消息", imageName: "bookmark", tag: .latestNews),
            .init(title: "发现", imageName: "magnifyingglass", tag: .discover),
            .init(title: "设置", imageName: "gear", tag: .settings)
        ])

    }
}

struct TabBar: View {
    @Binding var selectedTab: HomeView.Tab
    let tabs: [TabBarItem]
     var body: some View {
        ZStack {
            
             HStack {
                ForEach(tabs) { tab in
                    Button(action: {
                        selectedTab = tab.tag
                    }) {
                        VStack {
                            Image(systemName: tab.imageName)
                                // 颜色
                                .font(.system(size: 20, weight: .medium))
                            Text(tab.title)
                                .font(.system(size: 10, weight: .bold))
                                
                                .padding(4)
                         }
                    }
                    .foregroundColor(selectedTab == tab.tag ? Color(.init(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)) : Color(.init(red: 60/255, green: 60/255, blue: 60/255, alpha: 0.5)))
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let tag: HomeView.Tab
}

