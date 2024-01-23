//
//  DoubleTapPracticeView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapImageView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    @StateObject private var doubleTapVM = DoubleTapViewModel()
    
    
    private let UIWidth = UIScreen.main.bounds.width
    private let UIHeight = UIScreen.main.bounds.height
    private let selectedGuideVideo: URLManager = .doubleTapImageView
    
    var body: some View {
        VStack(spacing: 0) {
            CustomToolbar(title: "두 번 누르기", isSuccess: doubleTapVM.isSuccess)
                .zIndex(1)
            
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                Image("ex_image")
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(doubleTapVM.isSuccess ? 3 : 1)
                    .ignoresSafeArea()
                    .gesture(gesture)
                    .overlay {
                        if doubleTapVM.isSuccess {
                            ConfettiView()
                        }
                    }
                
                VStack(spacing: 0) {
                    Text(doubleTapVM.isSuccess ? "성공!\n" : doubleTapVM.isFail ? "조금만 더 빠르게 두 번\n눌러주세요!" : "빠르게 두 번 눌러\n사진을 확대해볼까요?")
                        .foregroundColor(doubleTapVM.isFail && !doubleTapVM.isSuccess ? .accentColor : .primary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .font(.customTitle)
                        .padding(.top, 40)
                        .frame(maxHeight: .infinity, alignment: .top)
                    
                    HelpButton(selectedGuideVideo: selectedGuideVideo, style: doubleTapVM.isFail ? .primary : .secondary)
                        .opacity(doubleTapVM.isSuccess ? 0 : 1)
                        .animation(.easeInOut, value: doubleTapVM.isSuccess)
                }
            }
            .modifier(FinishModifier(isNavigate: $doubleTapVM.isNavigate, isSuccess: $doubleTapVM.isSuccess))
            .onAppear {
                doubleTapVM.reset()
            }
        }
    }
    
    private var gesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    doubleTapVM.isSuccess.toggle()
                    doubleTapVM.isTapped = true
                }
            }
            .exclusively(
                before: TapGesture()
                    .onEnded {
                        withAnimation {
                            doubleTapVM.isTapped.toggle()
                            doubleTapVM.isFail = true
                        }
                    })
    }
}

struct DoubleTapPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTapImageView()
    }
}
