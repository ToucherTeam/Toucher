//
//  SwiftPracticeView2.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/06.
//

import SwiftUI

struct SwiftPracticeView2: View {
    @StateObject var swipeVM = SwipeViewModel()

    var body: some View {
        ZStack {
            VStack {
                CustomToolbar(title: "살짝 쓸기")
                
                Text(
                    swipeVM.btnActive ?
                    messageData.isEmpty ? "잘하셨어요!"
                    : "잘하셨어요!\n\n" : "메시지를 밀어서\n삭제해 보세요\n"
                )
                    .font(.customTitle)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                Spacer()
                List {
                    ForEach(messageData, id: \.id) { message in
                        HStack {
                            Image(systemName: message.imageName)
                                .foregroundColor(.customGR1)
                                .font(.system(size: 60))
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(message.phNumber).bold()
                                    Spacer()
                                    Text(message.time)
                                    Image(systemName: "chevron.right")
                                }
                                Text(message.text)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                swipeVM.btnActive = true
                                self.deleteMessage(message)
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                            } label: {
                                Image(systemName: "bell.slash.fill")
                            }
                            .tint(Color.purple)
                            .disabled(true)
                        }
                    }
                }
                .listStyle(.plain)
                Spacer()
            }

            if swipeVM.btnActive {
                ToucherNavigationLink {
                    SwipeFinalView()
                }
            }
        }
    }

    func deleteMessage(_ message: MessageModel) {
        messageData.removeAll(where: { $0 == message })
    }
}

struct SwiftPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SwipeExampleView()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            .previewDisplayName("iPhone SE")
            
            NavigationView {
                SwipeExampleView()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")
        }
    }
}
