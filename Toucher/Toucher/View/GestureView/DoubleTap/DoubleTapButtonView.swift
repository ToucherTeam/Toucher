//
//  DoubleTapButtonView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapButtonView: View {
    @StateObject private var doubleTapVM = DoubleTapViewModel()
    
    var body: some View {
        ZStack {
            if doubleTapVM.isFail && !doubleTapVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "두 번 누르기", isSuccess: doubleTapVM.isSuccess)
                
                ZStack {
                    VStack {
                        Text(doubleTapVM.isSuccess ? "성공!\n" : doubleTapVM.isFail ? "조금만 더 빠르게\n두 번 눌러주세요!" : "빠르게 두 번\n눌러볼까요?")
                            .foregroundColor(doubleTapVM.isFail && !doubleTapVM.isSuccess ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .font(.customTitle)
                            .padding(.top, 40)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        HelpButton(style: doubleTapVM.isFail ? .primary : .secondary, currentViewName: "DoubleTapExampleView")
                            .opacity(doubleTapVM.isSuccess ? 0 : 1)
                            .animation(.easeInOut, value: doubleTapVM.isSuccess)
                    }
                    
                    DoubleTapButton(isSuccess: $doubleTapVM.isSuccess, isFail: $doubleTapVM.isFail)
                        .padding(.bottom)
                        .overlay {
                            if doubleTapVM.isSuccess {
                                ConfettiView()
                            }
                        }
                }
            }
        }
        .modifier(MoveToNextModifier(isNavigate: $doubleTapVM.isNavigate, isSuccess: $doubleTapVM.isSuccess))
        .navigationDestination(isPresented: $doubleTapVM.isNavigate) {
            DoubleTapSearchBarView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            doubleTapVM.reset()
        }
    }
}

#Preview {
    DoubleTapButtonView()
        .environment(\.locale, .init(identifier: "ko"))
}
