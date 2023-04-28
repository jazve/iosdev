import Foundation
import Combine

class FeedViewModel: ObservableObject {
    // 订阅源列表
    @Published var feeds: [Feed] = []
    // 订阅源的订阅
    private var cancellables = Set<AnyCancellable>()
    
    // 加载默认订阅源
    func loadFeeds() {
        if feeds.isEmpty {
            let defaultFeeds = [
                "https://www.ithome.com/rss",
                "https://www.zhihu.com/rss",
                "https://sspai.com/feed",
                "https://www.vgtime.com/rss.jhtml",
                "https://www.huxiu.com/rss/0.xml",
   
                "https://www.iplaysoft.com/feed",
                "https://www.appinn.com/feed",
                "https://www.macdo.cn/feed",
                
            ]
            defaultFeeds.forEach { url in
                addFeed(url: URL(string: url)!)
            }

            // 保存订阅源列表到本地存储
            let defaults = UserDefaults.standard
            defaults.set(feeds.map { $0.url.absoluteString }, forKey: "feeds")
        }
        
    }
    
    // 添加订阅源
    func addFeed(url: URL) {
        let feedParser = FeedParser()
        let publisher = feedParser.parseFeed(url: url)
        let mainThreadPublisher = publisher.receive(on: DispatchQueue.main)
        let sink = mainThreadPublisher.sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("添加订阅源失败: \(error)")
            }
        }, receiveValue: { feed in
            self.handleNewFeed(feed)
        })
        sink.store(in: &cancellables)
    }
    
    // 处理新的订阅源
    private func handleNewFeed(_ feed: Feed) {
        feeds.append(feed)
        // 在这里实现保存订阅源列表的逻辑，例如保存到本地存储
    }
    
    // 删除订阅源
    func deleteFeed(at offsets: IndexSet) {
        offsets.sorted().reversed().forEach { index in
            feeds.remove(at: index)
        }
        // 在这里实现更新存储的逻辑，例如保存到本地存储
    }
    
    // 取消订阅
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

