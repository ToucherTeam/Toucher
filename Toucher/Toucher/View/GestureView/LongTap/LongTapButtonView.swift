//
//  LongTapExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapButtonView: View {
    @StateObject private var longTapVM = LongTapViewModel()
    
    var body: some View {
        ZStack {
            if longTapVM.isFail && !longTapVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "길게 누르기", isSuccess: longTapVM.isSuccess)
                
                ZStack {
                    VStack {
                        Text(longTapVM.isSuccess ? "성공!\n" : longTapVM.isFail ? "조금 더 길게 꾹 \n눌러주세요!" : "1초동안 길게\n눌러볼까요?")
                            .foregroundColor(longTapVM.isFail && !longTapVM.isSuccess ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .font(.customTitle)
                            .padding(.top, 40)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        HelpButton(style: longTapVM.isFail ? .primary : .secondary, currentViewName: "LongTapExampleView")
                            .opacity(longTapVM.isSuccess ? 0 : 1)
                            .animation(.easeInOut, value: longTapVM.isSuccess)
                    }
                    
                    LongPressButton(isSuccess: $longTapVM.isSuccess, isFail: $longTapVM.isFail)
                        .padding(.bottom)
                        .overlay {
                            if longTapVM.isSuccess {
                                ConfettiView()
                            }
                        }
                }
            }
            .modifier(
                MoveToNextModifier(
                    isNavigate: $longTapVM.isNavigate,
                    isSuccess: $longTapVM.isSuccess
                )
            )
            .navigationDestination(isPresented: $longTapVM.isNavigate) {
                LongTapCameraButtonView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
        .onAppear {
            longTapVM.reset()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    LongTapButtonView()
        .environment(\.locale, .init(identifier: "ko"))
}
