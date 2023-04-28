import SwiftUI
import RichText

struct ArticleView: View {
    @ObservedObject var viewModel: ArticleViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showBottomBar = false // 添加状态变量
    
    var body: some View {
        ScrollView { 
            VStack(alignment: .leading, spacing: 10) {
                // 显示作者信息
                Text("作者: \(viewModel.currentArticle?.author ?? "")")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 0.5)))
                    .padding(.top, 8)
                
                
                // 显示文章标题
                Text(viewModel.currentArticle?.title ?? "")
                    // 自定义标题样式
                    .font(.system(size: 24))
                    .lineSpacing(4)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 1)))             
                
                // 显示发布日期
                Text("发布于: \(viewModel.currentArticle?.publishDate ?? Date(), formatter: dateFormatter)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 0.5)))
                    .padding(.vertical, 12)
                
                // 渲染 HTML 内容
                RichText(html: viewModel.currentArticle?.content ?? "")
                    .lineHeight(160)
                    .colorScheme(.auto)
                    .fontType(.system)
                    .foregroundColor(light: Color(.init(red: 71/255, green: 71/255, blue: 70/255, alpha: 1)), dark: Color.primary)
                    .imageRadius(10)
                    .linkColor(light: Color.blue, dark: Color.blue)
                    .colorPreference(forceColor: .onlyLinks)
                    .linkOpenType(.SFSafariView())
                    .customCSS("img { width: 100%; height: auto; padding: 20,0;}, p { font-size: 14px; margin-top: 32px;margin-bottom: 32px; }")
                    .placeholder {
                        Text("加载中...")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(.init(red: 71/255, green: 71/255, blue: 70/255, alpha: 1)))
                            .padding(.vertical, 16)
                    }
                    .transition(.easeOut)
            }
            .frame(maxWidth: 800, alignment: .center)
            .padding(.horizontal, 24)
            
        }
        .padding(.top, 24)
        // Add a bottom bar with icons for previous, next, favorite, like, and close actions
        
        // 分割线
        Divider()
            .padding(.horizontal,22)
            .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 0.35)))
            .opacity(0.5)
        
        HStack {
            Button(action: {
                withAnimation {
                    viewModel.previousArticle()
                    if viewModel.currentArticle == nil {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Button(action: {
                // Implement favorite action here
            }) {
                Image(systemName: "textformat")
            }
            Spacer()
            Button(action: {
                // Implement like action here
            }) {
                Image(systemName: "heart")
            }
            Spacer()
            Button(action: {
                // Implement close action here
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle")
            }
            Spacer()
            Button(action: {
                withAnimation {
                    viewModel.nextArticle()
                    if viewModel.currentArticle == nil {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Image(systemName: "chevron.right")
            }
        }
        .font(.system(size: 18))
        .fontWeight(.bold)
        .padding(.horizontal, 32)
        .padding(.vertical, 4)
        .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 0.4)))
        // .background(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 0.05)))
        // .cornerRadius(16)
        // .shadow(radius: 10)
        // 宽度
        // .frame(width: UIScreen.main.bounds.width - 40)
        
        
        // 添加手势识别
        .gesture(
            DragGesture()

                .onChanged { _ in
                    showBottomBar = false
                }

                .onEnded { value in

                    // 显示隐藏底部工具栏
                    if value.translation.height < -50 {
                        showBottomBar = true
                    } else if value.translation.height > 50 {
                        showBottomBar = false
                    } else {
                        showBottomBar = true
                    }         

                    // 判断是否滚动到页面底部
                    print(value.location.y, UIScreen.main.bounds.height)
                    if value.location.y > UIScreen.main.bounds.height - 100 {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                    if value.translation.width > 100 {
                        // 右滑返回上一篇文章
                        
                        // 动画效果
                        withAnimation {
                            viewModel.previousArticle()

                            // 如果已经是第一篇文章，则返回上一级页面
                            if viewModel.currentArticle == nil {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } else if value.translation.width < -100 {
                        // 左滑切换到下一篇文章
                        
                        // 动画效果
                        withAnimation {
                            viewModel.nextArticle()

                            // 如果已经是最后一篇文章，则返回上一级页面
                            if viewModel.currentArticle == nil {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }

                    }
                }
                
        )

    }

    // 日期格式化器
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

