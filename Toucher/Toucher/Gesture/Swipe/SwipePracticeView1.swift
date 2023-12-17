//
//  SwiftPracticeView1.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/05.
//

import SwiftUI

struct SwipePracticeView1: View {
    @StateObject var swipeVM = SwipeViewModel()
    
    @State private var isSuccess = false
    @State private var isFail = false
    @State private var navigate = false
    
    var text = ["왼쪽으로 밀어볼까요?\n", "삭제버튼이 나왔어요.\n다음 것도 밀어볼까요?", "성공!\n",]
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "살짝 쓸기")
                
                Text(isFail ? "왼쪽으로\n살짝 쓸어보세요." : text[swipeVM.index])
                    .foregroundColor(isFail && !isSuccess ? Color.customWhite : Color.black)
                    .font(.customTitle)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .padding(.bottom, 108)
                
                List {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color.customBG2)
                                .font(.system(size: 60))

                            VStack(alignment: .leading) {
                                HStack {
                                    Text("phNumber")
//                                    Spacer()
                                    Text("message.time")

                                    Image(systemName: "chevron.right")
                                }
                                Text("message.text")
                            }
                            .foregroundColor(Color.customBG2)
                            
                        }
                    
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if value.translation.width < 0 {
                                        isFail = false
                                    } else {
                                        if !isSuccess {
                                            withAnimation {
                                                isFail = true
                                            }
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    // Handle the end of drag if needed
                                }
                        )
                        .swipeActions(allowsFullSwipe: false) {
                            Button() {
                                
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .tint(.red)
                            .onAppear {
                                isFail = false
                                swipeVM.index = 1
                            }
                            
                        }
                        .overlay(alignment: .trailing) {
                            if swipeVM.index == 0 {
                                Arrows()
                                    .offset(x: 40, y: -2)
                                    .allowsHitTesting(true)
                            }
                        }
                        .listRowBackground(Color.customBG2)
                }
                .scrollDisabled(true)
                .frame(height: 90)
                .frame(width: UIScreen.main.bounds.width - 32)
                .cornerRadius(20)
                .listStyle(.plain)
                .padding(.bottom, 6)
                List {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color.customBG2)
                                .font(.system(size: 60))

                            VStack(alignment: .leading) {
                                HStack {
                                    Text("phNumber")
//                                    Spacer()
                                    Text("message.time")

                                    Image(systemName: "chevron.right")
                                }
                                Text("message.text")
                            }
                            .foregroundColor(Color.customBG2)
                            
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                
                            } label: {
                                Image(systemName: "envelope.badge.fill")
                            }
                            .tint(Color.blue)
                            .onAppear {
                                isFail = false
                                swipeVM.index = 2
                                isSuccess = true
                            }
                            
                        }
                        .overlay(alignment: .leading) {
                            if swipeVM.index == 1 {
                                Arrows()
                                    .rotationEffect(.degrees(180))
                                    .offset(x: -10, y: -2)
                                    .allowsHitTesting(true)
                            }
                        }
                        .listRowBackground(Color.customBG2)
                }
                .scrollDisabled(true)
                .frame(height: 90)
                .frame(width: UIScreen.main.bounds.width - 32)
                .cornerRadius(20)
                .listStyle(.plain)
                
                Spacer()
                
                HelpButton(style: .secondary) {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
            }
            
        }
        .frame(maxHeight: .infinity)
        .onDisappear {
            swipeVM.index = 0
            isSuccess = false
        }
        .overlay {
            if isSuccess {
                ConfettiView()
            }
        }
        .onChange(of: isSuccess ) { _ in
            if swipeVM.index == 2 {
                isSuccess = true
                HapticManager.notification(type: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    navigate = true
                }
            }
        }
        .navigationDestination(isPresented: $navigate) {
            SwipePracticeView2()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    NavigationStack {
        SwipePracticeView1()
    }
}
