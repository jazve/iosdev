import SwiftUI
import Kingfisher

struct FeedListView: View {
    @ObservedObject private var feedViewModel = FeedViewModel()

    var body: some View {
        VStack {
            // 顶部导航栏
            HStack {
                // 标题
                Text("Chat RSS")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 1)))

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
            .padding(.horizontal, 16)
            .padding(.vertical, 16)

            // List列表
            FeedList(feeds: feedViewModel.feeds)
                .background(Color(.init(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)))
                
        }
        .onAppear {
            feedViewModel.loadFeeds()
        }
    }
}

struct FeedList: View {
    let feeds: [Feed]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                ForEach(feeds.sorted(by: { $0.title < $1.title }), id: \.id) { feed in
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
                .padding(.horizontal, 16)
            }
            // 隐藏列表分割线，箭头
            .listStyle(PlainListStyle())
            // 背景色
            .background(Color(.init(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)))
        }
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
            VStack(alignment: .leading) {
                Text(feed.title)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
                    // 文字颜色
                    .foregroundColor(Color(.init(red: 61/255, green: 61/255, blue: 63/255, alpha: 1)))

                // 显示最新的一条文章标题
                if let article = feed.articles.first {
                    Text(article.title)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .padding(.top, 1)
                }
                
            }
            .padding(.leading, 4)
            
            Spacer()
            
            //右侧时间与未读数
            VStack(alignment: .trailing) {
                // 显示最新的一条文章的发布时间
                // if let article = feed.articles.first {
                //     Text(article.date, style: .date)
                //         .font(.system(size: 10))
                //         .foregroundColor(.gray)
                // }
                
                // 未读数
                if feed.unreadItemCount > 0 {
                    
                    Text("\(feed.unreadItemCount)")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        // 背景色
                        .frame(width: 24, height: 24)
                        .background(Color(.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.05)))
                        
                        // 圆角
                        .clipShape(Circle())
                }
            }
            
            
            
        }
    }
}
