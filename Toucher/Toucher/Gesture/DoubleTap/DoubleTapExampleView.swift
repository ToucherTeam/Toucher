//
//  DoubleTapExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapExampleView: View {

    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isFail = false
    @State private var navigate = false
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "두 번 누르기", isSuccess: isSuccess)
                
                Text(isSuccess ? "성공!\n" : isFail ? "조금만 더 빠르게\n두 번 눌러주세요!" : "빠르게 두 번\n눌러볼까요?")
                    .foregroundColor(isFail && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                DoubleTapButton(isSuccess: $isSuccess, isFail: $isFail)
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
            DoubleTapPracticeView1()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            reset()
        }
    }
    
    private func reset() {
        isTapped = false
        isSuccess = false
        isFail = false
    }
}

struct DoubleTapExampleView_Previews: PreviewProvider {
    static var previews: some View {
            DoubleTapExampleView()
    }
}
