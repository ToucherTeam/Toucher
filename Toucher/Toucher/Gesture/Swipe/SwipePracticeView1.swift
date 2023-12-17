//
//  SwiftPracticeView1.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/05.
//

import SwiftUI

struct SwipePracticeView1: View {
    @StateObject var swipeVM = SwipeViewModel()
    
    var text = ["왼쪽으로\n밀어볼까요?", "삭제버튼이 나왔어요.\n다음 것도 밀어볼까요?", "이번엔 메일 읽음\n버튼이 나왔어요!"]
    
    var body: some View {
        ZStack {
            VStack {
                CustomToolbar(title: "살짝 쓸기")
                
                Text(text[swipeVM.index])
                    .font(.customTitle)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                VStack(spacing: 16) {
                    List {
                        HStack {
                            if swipeVM.index == 0 {
                                Spacer()
                                Arrows()}
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                
                            } label: {
                                Image(systemName: "trash.fill")
                                    .onAppear {
                                        swipeVM.index = 1
                                        swipeVM.checkSuccess = true
                                    }
                            }
                            .tint(.red)
                        }
                        .frame(height: 100)
                        .listRowBackground(Color.customBG2)
                    }
                    .cornerRadius(20)
                    .scrollDisabled(true)
                    .listStyle(.plain)
                    .frame(height: 120)
                    
                    List {
                        HStack {
                            Arrows()
                                .rotationEffect(.degrees(180))
                            
                            Spacer()
                        }
                        .opacity(swipeVM.index == 1 ? 1 : 0)
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                            } label: { Image(systemName: "envelope.badge.fill") }.tint(.blue)
                                .onAppear {
                                    swipeVM.index = 2
                                }
                                .onDisappear {
                                    swipeVM.index = 0
                                }
                        }
                        .frame(height: 100)
                        .listRowBackground(Color.customBG2)
                    }
                    .cornerRadius(20)
                    .scrollDisabled(true)
                    .disabled(!swipeVM.checkSuccess)
                    .listStyle(.plain)
                    .frame(height: 120)
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }

            if swipeVM.index == 2 {
                ToucherNavigationLink {
                    SwipePracticeView2()
                }
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            swipeVM.checkSuccess = false
        }
    }
}

#Preview {
    NavigationStack {
        SwipePracticeView1()
    }
}