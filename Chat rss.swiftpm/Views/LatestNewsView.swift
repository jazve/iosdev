import SwiftUI

struct LatestNewsView: View {
    var body: some View {
        // 创建窗口标题
        NavigationView {
            // 创建列表
            List {
                // 创建列表项
                ForEach(0..<10) { item in
                    // 创建导航链接
                    NavigationLink(destination: Text("Detail \(item)")) {
                        // 创建列表项内容
                        HStack {
                            Image(systemName: "photo")
                            Text("Title \(item)")
                        }
                    }
                }
            }
            // 设置窗口标题
            .navigationBarTitle("Latest News")
        }
    }
}
