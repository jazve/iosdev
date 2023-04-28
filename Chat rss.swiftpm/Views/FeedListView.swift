import SwiftUI
import Kingfisher

struct FeedListView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel

    var body: some View {
        VStack(spacing: 0) {
            // 顶部导航栏
            HStack {
                // 标题
                VStack(alignment: .leading,spacing: 2) {
                    Text("Chat RSS")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 1)))
                    
                    Text("Stay hungry, stay foolish")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 0.3)))

                }
                
                Spacer()


                // 搜索按钮
                Button(action: {
                    print("搜索")
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 1)))
                        .padding(12)
                        .background(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 0.05)))
                        .clipShape(Circle())
                }

                // 用户头像

                Button(action: {
                    
                }) {
                    Image(systemName: "person.crop.circle.fill")                
                        .foregroundColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 1)))
                        .padding(12)
                        .background(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 0.05)))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            // Divider()
            //     .padding(.horizontal, 20)
            //     .opacity(0.5)

            // List列表
            FeedList(feeds: feedViewModel.feeds)
                .background(Color(.init(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)))
                
        }
        // 加载数据
        .onAppear {
            feedViewModel.loadFeeds()
        }
    }
}

struct FeedList: View {
    
    let feeds: [Feed]
    var groupedFeeds: [String: [Feed]] = [:]
    
    init(feeds: [Feed]) {
        self.feeds = feeds
        
        feeds.sorted(by: { (feed1, feed2) -> Bool in
            if let date1 = feed1.articles.first?.publishDate, let date2 = feed2.articles.first?.publishDate {
                return date1 > date2
            }
            return false
        })
        
        // 将订阅源分组
        let calendar = Calendar.current
        let now = Date()
        for feed in feeds {
            if let publishDate = feed.articles.first?.publishDate {
                let components = calendar.dateComponents([.day], from: publishDate, to: now)
                let daysAgo = components.day ?? 0
                var dateString = ""
                // 今天
                if calendar.isDateInToday(publishDate) {
                    dateString = "今天"
                // 昨天
                } else if calendar.isDateInYesterday(publishDate) {
                    dateString = "昨天"
                // 前天
                // } else if daysAgo == 2 {
                //     dateString = "前天"
                // 更早
                } else {
                    dateString = "更早"
                }
                
                if groupedFeeds[dateString] == nil {
                    groupedFeeds[dateString] = [feed]
                } else {
                    groupedFeeds[dateString]?.append(feed)
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], alignment: .leading, spacing: 2) {
                ForEach(groupedFeeds.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Section(header: Text(key).padding(.top, 16)) {
                        ForEach(value, id: \.id) { feed in
                            NavigationLink(destination: FeedDetailView(feed: feed)) {
                                FeedRow(feed: feed)
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(16)
                            }
                            // 隐藏箭头
                            .buttonStyle(PlainButtonStyle())
                            .listRowBackground(Color.clear)
                        }
                        
                    }
                    // 字体
                    .padding(4)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 0.5)))
                }
            }
            .padding(.horizontal, 16)
        }
        .background(Color(.init(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)))
    }
}


struct FeedRow: View {
    let feed: Feed

    var body: some View {
        HStack {  
            
            if let iconURL = feed.iconURL {
                
                KFImage(iconURL)
                    .resizable()
                    
                    .padding(8)
                    .frame(width: 50, height: 50)
                    .background(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 0.05)))
//                    .colorMultiply(.gray) // 图片黑白处理
                    .cornerRadius(16)
            } else {
                Image(systemName: "photo")
                
                    .font(.system(size: 20))
                    .frame(width: 50, height: 50)
                    
                    // 图标颜色
                    .foregroundColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 0.5)))
                    // 背景色
                    .background(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 0.05)))
                    // 矩形圆角
                    .cornerRadius(16)
                    
            }

            VStack (alignment: .leading, spacing: 2) {
                HStack{
                    Text(feed.title)
                        .font(.system(size: 16, weight: .bold))
                        .lineLimit(1)
                        // 文字颜色
                        .foregroundColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 1)))

                    Spacer()

                    // 显示最新的一条文章时间并格式化为字符串
                    if let article = feed.articles.first {
                        Text("\(article.publishDate, formatter: dateFormatter)")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .opacity(0.5)
                    }
                }
                
            
                //右侧时间与未读数
                HStack {
                    
                    // 显示最新的一条文章标题
                    if let article = feed.articles.first {
                        Text(article.title)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .padding(.top, 1)
                    }
                    
                    Spacer()

                    // 未读数
                    if feed.unreadItemCount > 0 {
                        
                        Text("\(feed.unreadItemCount)")
                            .font(.system(size: 11))
                            .fontWeight(.medium)
                            .foregroundColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 0.5)))
                            .padding(6)
                            .background(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 0.10)))
                            .clipShape(Circle())
                    }
                }

            }

            .padding(4)
            
        }
    }

    // 日期格式化器
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // 不显示年份
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        // 显示早上、下午、晚上
        formatter.amSymbol = "上午"
        formatter.pmSymbol = "下午"
        
        return formatter
    }()
}
