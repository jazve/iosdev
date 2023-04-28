// 创建一个SwiftUI组件，模仿RSS阅读器Reeder 5，创建一个文章阅读列表底部操作栏，左边为全部设为已读，中间为筛选：收藏，未读，全部，右侧为搜索图标，配合平滑的动画效果
import SwiftUI

struct ArticleListBottomBar: View {
    var body: some View {
        
        HStack {

            Button(action: {
                // 点击全部设为已读
            }) {
                Image(systemName: "magnifyingglass")
            }
            Spacer()

            // Picker(selection: .constant(0), label: Text("筛选")) {
            //     Text("收藏").tag(0)
            //     Text("未读").tag(1)
            //     Text("全部").tag(2)
            // }
            // // 宽度300
            // .frame(width: 300)
            // // 背景透明
            // .background(Color.clear)
            // // 选择器样式
            // .pickerStyle(SegmentedPickerStyle())
            // // 选中圆角
            // .cornerRadius(16)
            
            HStack{
                Button(action: {
                // Implement favorite action here
                }) {
                    Image(systemName: "calendar")
                }
                Spacer()
                Button(action: {
                    // Implement like action here
                }) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: {
                    // Implement close action here
                    
                }) {
                    Image(systemName: "star")
                }
            }
            .font(.system(size: 14))
            .frame(width: 140)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 0.05)))
            .cornerRadius(25)
            
            Spacer()
            Button(action: {
                // 点击搜索
            }) {
                Image(systemName: "checkmark.circle.fill")
            }
        }
        .font(.system(size: 18))
        .fontWeight(.bold)
        .padding(.top, 6)
        .foregroundColor(Color(.init(red: 63/255, green: 63/255, blue: 61/255, alpha: 0.4)))
        // .padding()
        // .background(Color.gray.opacity(0.2))
    }
}
