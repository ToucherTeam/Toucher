//
//  SwiftPracticeView2.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/06.
//

import SwiftUI

struct SwipeMessageView: View {
    @StateObject var swipeVM = SwipeViewModel()
    
    private let selectedGuideVideo: URLManager = .swipeMessageView
    
    var body: some View {
        ZStack {
            if swipeVM.isFail && !swipeVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "살짝 쓸기", isSuccess: swipeVM.isSuccess)
                
                ZStack {
                    VStack {
                        Text(swipeVM.isFail ? "왼쪽으로\n살짝 쓸어보세요.\n" : swipeVM.isSuccess ? "성공!\n\n" : "메시지를 왼쪽으로 밀어서\n삭제해 보세요\n")
                            .foregroundColor(swipeVM.isFail && !swipeVM.isSuccess ? Color.customWhite : Color.black)
                            .font(.customTitle)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        HelpButton(selectedGuideVideo: selectedGuideVideo, style: swipeVM.isFail  ? .primary : .secondary)
                            .opacity(swipeVM.isSuccess ? 0 : 1)
                            .animation(.easeInOut, value: swipeVM.isSuccess)
                    }
                    
                    List {
                        ForEach(swipeVM.messageData, id: \.id) { message in
                            HStack {
                                Image(systemName: message.imageName)
                                    .foregroundColor(swipeVM.isFail && !swipeVM.isSuccess ? Color.customWhite : Color.customGR1)
                                    .font(.system(size: 60))
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(message.phNumber)
                                            .bold()
                                            .foregroundColor(swipeVM.isFail && !swipeVM.isSuccess ? Color.customWhite : Color.black)
                                            .gesture(
                                                DragGesture()
                                                    .onChanged { value in
                                                        if value.translation.width < 0 {
                                                            swipeVM.isFail = false
                                                        } else {
                                                            if !swipeVM.isSuccess {
                                                                withAnimation {
                                                                    swipeVM.isFail = true
                                                                }
                                                            }
                                                        }
                                                    }
                                            )
                                        
                                        Spacer()
                                        
                                        Text(message.time)
                                            .foregroundColor(swipeVM.isFail && !swipeVM.isSuccess ? Color.customWhite : Color.black)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(swipeVM.isFail && !swipeVM.isSuccess ? Color.customWhite : Color.black)
                                    }
                                    Text(message.text)
                                        .foregroundColor(swipeVM.isFail && !swipeVM.isSuccess ? Color.customWhite : Color.black)
                                }
                            }
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    swipeVM.isFail = false
                                    swipeVM.isSuccess = true
                                    if let index = swipeVM.messageData.firstIndex(where: { $0.id == message.id }) {
                                        swipeVM.messageData.remove(at: index)
                                    }
                                    
                                    print("Deleting conversation")
                                } label: {
                                    Image(systemName: "trash.fill")
                                }
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "bell.slash.fill")
                                }
                                .tint(.indigo)
                            }
                            .listRowBackground(swipeVM.isFail ? Color.customSecondary : Color.customWhite)
                        }
                        
                    }
                    .listStyle(.plain)
                    .scrollDisabled(true)
                    .padding(.top, 200)
                }
            }
        }
        .overlay {
            if swipeVM.isSuccess {
                ConfettiView()
            }
        }
        .modifier(FinishModifier(isNavigate: $swipeVM.isNavigate, isSuccess: $swipeVM.isSuccess))
    }
}

#Preview {
    NavigationStack {
        SwipeMessageView()
            .environment(\.locale, .init(identifier: "ko"))
    }
}
