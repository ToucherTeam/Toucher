//
//  LongTapExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapExampleView: View {
    @State private var isTapStart = false
    @State private var isSuccess = false
    @State private var isFail = false
    @State private var navigate = false
        
    @State private var animate = [false, false, false]
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "길게 누르기")

                Text(isSuccess ? "성공!\n" : isFail ? "조금 더 길게 꾹 \n눌러주세요!" : "1초동안 길게\n눌러볼까요?")
                    .foregroundColor(isFail && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                
                LongPressButton(isSuccess: $isSuccess, isFail: $isFail)
                    .padding(.bottom)
                    .frame(maxHeight: .infinity)
                    .overlay {
                        if isSuccess {
                            ConfettiView()
                        }
                    }

                HelpButton(style: isFail ? .primary : .secondary) {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
            }
            .onChange(of: isSuccess) { _ in
                if isSuccess {
                    HapticManager.notification(type: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        navigate = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigate) {
                LongTapPracticeView1()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
        .onAppear {
            reset()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
        
    private func reset() {
        isTapStart = false
        isSuccess = false
        isFail = false
    }
}

struct LongTapExampleView_Previews: PreviewProvider {
    static var previews: some View {
        LongTapExampleView()
    }
}
