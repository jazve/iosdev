import SwiftUI

@main
struct MyApp: App {
    @AppStorage("nightMode") private var nightMode: Bool = false

    // 从本地存储中加载订阅源
    @StateObject private var feedViewModel = FeedViewModel()
    
    init() {
        // 隐藏导航栏下面的分割线
        UINavigationBar.appearance().shadowImage = UIImage()
        // 去除导航栏的半透明效果
        // UINavigationBar.appearance().isTranslucent = false
        // 设置导航栏背景色
        UINavigationBar.appearance().backgroundColor = UIColor(Color(.init(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)))
        // 全局背景色
        UITableView.appearance().backgroundColor = UIColor(Color(.init(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)))
        // 全局字体颜色
        UITableViewCell.appearance().textLabel?.textColor = UIColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 1)))
        // 导航栏返回按钮字体颜色
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 1)))]
        UINavigationBar.appearance().tintColor = UIColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 1)))

        
        // 从本地存储中加载订阅源
        feedViewModel.loadFeeds()
    }
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nightMode ? .dark : .light)
                .environmentObject(feedViewModel)
        }
    }
}

