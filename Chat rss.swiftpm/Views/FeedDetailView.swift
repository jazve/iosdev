import SwiftUI
import Kingfisher



struct BubbleView: View {
    
    let article: Article
    let maxWidth: CGFloat
    
    // 添加一个占位符图像
    var placeholder: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(.systemGray6))
            .opacity(0.9)
            .frame(width: 48 ,height: 48)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            //             文章图片
            if let imageURL = article.imageURL {
//               
               KFImage(URL(string: imageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .cornerRadius(10)
                
            } else {
                placeholder
            }
            
            // 文章标题
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                        
//                    .foregroundColor(Color(.init(red: 40/255, green: 40/255, blue: 120/255, alpha: 1)))
                    .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 1)))
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                
            }
            
            .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
//            .background(Color(.init(red: 238/255, green: 242/255, blue: 255/255, alpha: 1)))
            .background(.white)
            // 边框
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 0.05)), lineWidth: 1)
            )
            .cornerRadius(15)
            .frame(maxWidth: maxWidth*0.85, alignment: .leading)
        
        }
        .padding(4)
       Spacer()
//        .colorScheme(.light)
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}



enum Filter: String, CaseIterable, Identifiable {
    case all = "全部"
    case unread = "未读"
    case read = "已读"
    
    var id: String { self.rawValue }
}



struct FeedDetailView: View {
    
    
    @StateObject var feed: Feed
    @State private var showArticleView = false
    @State private var selectedArticleViewModel: ArticleViewModel?
    @State private var filter: Filter = .all
    @State private var searchText: String = ""
    
    // 添加自动设置已读的状态
    @State private var autoMarkAsRead = false
    
    var filteredArticles: [Article] {
        feed.articles.sorted(by: { $0.publishDate > $1.publishDate }).filter { article in
            switch filter {
            case .all:
                return true
            case .unread:
                return !article.isRead
            case .read:
                return article.isRead
            }
        }
    }

    
    // 在 FeedDetailView 中添加一个方法来计算显示发布时间的间隔
    func shouldDisplayTimeInterval(_ index: Int) -> Bool {
        guard index > 0 else { return true }
        
        let currentArticle = filteredArticles[index]
        let previousArticle = filteredArticles[index - 1]
        
        let currentHourSegment = Calendar.current.component(.hour, from: currentArticle.publishDate) / 1
        let previousHourSegment = Calendar.current.component(.hour, from: previousArticle.publishDate) / 1
        
        return currentHourSegment != previousHourSegment
    }
    
    var body: some View {
        
        VStack(spacing: 0){
            
            // 分割线
            Divider()
                .padding(.horizontal, 16)
                .opacity(0.5)

            GeometryReader { geometry in
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(filteredArticles.indices, id: \.self) { index in
                                let article = filteredArticles[index]
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    if shouldDisplayTimeInterval(index) {
                                        Text("\(article.publishDate, formatter: dateFormatter)")
                                        
                                            .font(.footnote)
                                            
                                            .foregroundColor(Color(.init(red: 71/255, green: 71/255, blue: 70/255, alpha: 0.5)))
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 12)
//                                            .background(Color(.init(red: 241/255, green: 245/255, blue: 249/255, alpha: 1)))
                                            .background(Color(.init(red: 71/255, green: 71/255, blue: 70/255, alpha: 0.05)))
                                            .cornerRadius(100)
                                            .padding(.vertical, 24)
                                            
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                    
                                        
                                    
                                    HStack {
                                        BubbleView(article: article, maxWidth: geometry.size.width * 0.85)
                                            .onTapGesture {
                                                if let index = feed.articles.firstIndex(where: { $0.id == article.id }) {
                                                    selectedArticleViewModel = ArticleViewModel(articles: feed.articles, currentIndex: index)
                                                    article.isRead = true // 设置为已读
                                                    // 保存已读消息
                                                    
                                                   
                                                    showArticleView = true
                                                    
//                                                    scrollViewProxy.scrollTo(article.id, anchor: .center) // 点击或在详情页出现后立即更新透明度
                                                }
                                            }
                                            .opacity(article.isRead ? 0.4 : 1.0) // 已读消息透明度改为50%
                                    }
                                }
                                .id(article.id)
                            }
                        }
                        .padding(10)


                    }
                    // 添加手势识别
                    .gesture(DragGesture()
                              .onEnded({ value in
                                // 如果打开自动设置已读
                                if autoMarkAsRead {
                                  // 获取消息ID
                                  let articleID = String( value.translation.height / 60 )
                                  // 如果消息已经超过屏幕底部
                                  if value.translation.height > geometry.size.height {
                                    // 设置对应消息为已读
                                    if let index = filteredArticles.firstIndex(where: { $0.id == articleID }) {
                                        feed.articles[index].isRead = true
                                        // 保存到本地
                                    
                                    }
                                  }
                                }
                              }))
                    
                    .navigationBarTitle(feed.title, displayMode: .inline)
                     // 导航栏返回按钮字体颜色
                    
                    .sheet(item: $selectedArticleViewModel) { viewModel in
                        ArticleView(viewModel: viewModel)
                            .onDisappear {
                                selectedArticleViewModel = nil
                            }
                    }
                //    .onAppear {
                //        // 滚动到最后一篇文章
                //        if let lastArticle = filteredArticles.last {
                //            scrollViewProxy.scrollTo(lastArticle.id, anchor: .bottom)
                //        }
                //    }
                }
            }

            //底部操作栏
            // 分割线
            Divider()
                .padding(.horizontal, 16)
                .padding(.bottom, 6)
                .opacity(0.5)

            ArticleListBottomBar()
                .padding(.horizontal, 24)

            
        }
        .background(Color(.init(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)))
        
        
    }
    
    // 日期格式化器
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // 不显示年份
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        // 显示为中文，今天、昨天、前天
        formatter.locale = Locale(identifier: "zh_CN")

        // 显示早上、下午、晚上
        formatter.amSymbol = "上午"
        formatter.pmSymbol = "下午"
        
        return formatter
    }()
    
    // 将日期划分为时间段
    private func timeSegment(for date: Date) -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return hour / 1
    }
    
}
