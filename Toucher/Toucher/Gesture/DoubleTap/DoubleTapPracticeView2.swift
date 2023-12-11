//
//  DoubleTapPracticeView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapPracticeView2: View {
    @StateObject private var navigationManager = NavigationManager.shared

    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isFail = false
    
    let UIWidth = UIScreen.main.bounds.width
    let UIHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            Image("ex_image")
                .resizable()
                .scaledToFit()
                .scaleEffect(isSuccess ? 2 : 1)
                .ignoresSafeArea()
                .gesture(gesture)
                .overlay {
                    if isSuccess {
                        ConfettiView()
                    }
                }
            
            VStack(spacing: 0) {
                CustomToolbar(title: "두 번 누르기")
                
                Text(isSuccess ? "성공!\n" : isFail ? "조금만 더 빠르게 두 번\n눌러주세요!" : "빠르게 두 번 눌러\n사진을 확대해볼까요?")
                    .foregroundColor(isFail && !isSuccess ? .accentColor : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                    .frame(maxHeight: .infinity, alignment: .top)
                
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
                    navigationManager.navigate = false
                    navigationManager.updateGesture()
                }
            }
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
    
    private var gesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    isSuccess.toggle()
                    isTapped = true
                }
            }
            .exclusively(
                before: TapGesture()
                    .onEnded {
                        withAnimation {
                            isTapped.toggle()
                            isFail = true
                        }
                    })
    }
}

struct DoubleTapPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTapPracticeView2()
    }
}
