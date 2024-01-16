//
//  SwipeListView.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/05.
//

import SwiftUI

struct SwipeListView: View {
    @StateObject var swipeVM = SwipeViewModel()
    
    @State private var textIndex = 0
    
    var body: some View {
        ZStack {
            if swipeVM.isFail && !swipeVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "살짝 쓸기", isSuccess: swipeVM.isSuccess)
                
                ZStack {
                    VStack {
                        titleText
                            .foregroundColor(swipeVM.isFail && !swipeVM.isSuccess ? Color.customWhite : Color.black)
                            .font(.customTitle)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                            .padding(.bottom, 108)
                        
                        Spacer()
                        
                        HelpButton(style: swipeVM.isFail ? .primary : .secondary, currentViewName: "SwipePracticeView1")
                            .opacity(swipeVM.isSuccess ? 0 : 1)
                            .animation(.easeInOut, value: swipeVM.isSuccess)
                    }
                    
                    VStack {
                        if swipeVM.isNavigate {
                            ForEach(0..<2, id: \.self) { _ in
                                List {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(Color.customBG2)
                                            .font(.system(size: 60))
                                    }
                                    .listRowBackground(Color.customBG2)
                                }
                                .modifier(ListModifier())
                            }
                        } else {
                            List {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(Color.customBG2)
                                        .font(.system(size: 60))
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("phNumber")
                                            
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
                                .swipeActions(allowsFullSwipe: false) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "trash.fill")
                                    }
                                    .tint(.red)
                                    .onAppear {
                                        swipeVM.isFail = false
                                        textIndex = 1
                                    }
                                }
                                .overlay(alignment: .trailing) {
                                    if textIndex == 0 {
                                        Arrows()
                                            .offset(x: 40, y: -2)
                                            .allowsHitTesting(true)
                                    }
                                }
                                .listRowBackground(Color.customBG2)
                            }
                            .modifier(ListModifier())
                            
                            List {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(Color.customBG2)
                                        .font(.system(size: 60))
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("phNumber")
                                            
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
                                        swipeVM.isFail = false
                                        textIndex = 2
                                        swipeVM.isSuccess = true
                                    }
                                    
                                }
                                .overlay(alignment: .leading) {
                                    if textIndex == 1 {
                                        Arrows()
                                            .rotationEffect(.degrees(180))
                                            .offset(x: -10, y: -2)
                                            .allowsHitTesting(true)
                                    }
                                }
                                .listRowBackground(Color.customBG2)
                            }
                            .modifier(ListModifier())
                        }
                    }
                }
            }
        }
        .onAppear {
            textIndex = 0
            swipeVM.reset()
        }
        .overlay {
            if swipeVM.isSuccess {
                ConfettiView()
            }
        }
        .modifier(MoveToNextModifier(isNavigate: $swipeVM.isNavigate, isSuccess: $swipeVM.isSuccess))
        .navigationDestination(isPresented: $swipeVM.isNavigate) {
            SwipeMessageView()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    private var titleText: some View {
        switch (swipeVM.isSuccess, textIndex, swipeVM.isFail) {
        case (true, _, false):
            Text("잘하셨어요!\n")
            
        case (false, 1, false):
            Text("삭제버튼이 나왔어요.\n다음 것도 밀어볼까요?")
            
        case (_, 0, true):
            Text("왼쪽으로\n 살짝쓸어보세요")
            
        case (false, 0, false):
            Text("왼쪽으로 밀어볼까요?\n")
            
        default:
            Text("왼쪽으로 밀어볼까요?\n")
        }
    }
}

struct ListModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollDisabled(true)
            .frame(height: 90)
            .frame(width: UIScreen.main.bounds.width - 32)
            .cornerRadius(20)
            .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SwipeListView()
            .environment(\.locale, .init(identifier: "ko"))
    }
}
