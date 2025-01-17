//
//  AIPromptPopView.swift
//  OSXChatGPT
//
//  Created by CoderChan on 2023/4/5.
//

import SwiftUI

struct AIPromptPopView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var data = AIPromptSessionViewMdoel()
    @Binding var showInputView: Bool
    @Binding var showPopover: Bool
    @State private var isPresented = false
    
    var titleColor: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.9)
        default:
            return Color.black.opacity(0.9)
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("选择提示")
                    .font(.title3)
                    .foregroundColor(titleColor)
                Spacer()
                
            }
            HStack {
                Button {
                    if let prompt = data.selectedItem {
                        viewModel.updateConversation(sesstionId: viewModel.currentConversation!.sesstionId, prompt: prompt)
                    }
                    self.showPopover = false
                } label: {
                    Text("确定")
                }.padding(10)
                Spacer()
                Button {
                    self.showPopover = false
                    withAnimation {
                        viewModel.currentConversation = nil
                        viewModel.showAIPrompt = true
                    }
                } label: {
                    Text("词库")
                }
                .padding(10)
            }
        }
        List(data.allPrompts) { item in
            AIPromptPopCellView(item: item, isSelected: data.selectedItem == item)
                .onTapGesture {
                    data.selectedItem = item
                }
                .contextMenu {
                    Button(action: {
                        withAnimation {
                            data.deletePrompt(prompt: item)
                        }
                    }) {
                        Text("移除快捷方式")
                    }
                }
        }.frame(width: 560, height: 380)
            .onAppear {
                if let conversation = viewModel.currentConversation {
                    data.fetchAllPrompts(session: conversation)
                }
            }
    }
}

struct AIPromptPopCellView: View {
    @Environment(\.colorScheme) private var colorScheme
    let item: Prompt
    let isSelected: Bool
    var body: some View {
        HStack {
            if self.isSelected {
                Image(systemName: "checkmark.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor((colorScheme == .dark) ? .white.opacity(0.8) : .white)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .padding(5)
                
            } else {
                Circle()
                    .stroke(Color.blue, lineWidth: 1)
                    .frame(width: 20, height: 20)
                    .padding(5)
            }
            if item.type == 1 {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("【默认无修饰语】")
                            .font(Font.system(size: 15))
                            .foregroundColor((colorScheme == .dark) ? .white.opacity(0.8) : .white)
                            .padding(.trailing, 6)
                            .padding(.bottom, 6)
                        Text("当前选中的修饰语")
                            .font(Font.system(size: 14))
                            .foregroundColor((colorScheme == .dark) ? .white.opacity(0.8) : .white)
                            .padding(.bottom, 6)
                        Spacer()
                        Text("(没有修饰语请到词库添加)")
                            .font(Font.system(size: 11))
                            .foregroundColor((colorScheme == .dark) ? .white.opacity(0.8) : .white)
                            .padding(.bottom, 6)
                    }
                    Text("每个会话只能选择一个修饰语, 也可以自定义添加修饰语")
                        .font(.subheadline)
                        .foregroundColor((colorScheme == .dark) ? .white.opacity(0.6) : .white)
                }.padding(.leading, 2)
            }else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title ?? "")
                        .font(.headline)
                        .foregroundColor((colorScheme == .dark) ? .white.opacity(0.8) : .white)
                        .foregroundColor(.primary)
                        .padding(.bottom, 6)
                    Text(item.prompt ?? "")
                        .font(.subheadline)
                        .foregroundColor((colorScheme == .dark) ? .white.opacity(0.6) : .white)
                }.padding(.leading, 2)
            }
            
            Spacer()
        }
        .frame(height: 60)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(
            item.color.brightness((self.colorScheme == .dark) ? -0.5 : -0.2)
        )
        .cornerRadius(6)
    }
}
//struct AIPromptPopView_Previews: PreviewProvider {
//    static var previews: some View {
//        AIPromptPopView()
//    }
//}
