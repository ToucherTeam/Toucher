//
//  PinchPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchPracticeView1: View {
    @StateObject private var navigationManager = NavigationManager.shared

    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isFail = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            CustomToolbar(title: "확대 축소하기")
                .zIndex(1)

            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                Image("ex_image")
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(scale)
                    .gesture(gesture)
                    .overlay {
                        if !isTapped || isFail && !isSuccess {
                            HStack(spacing: 100) {
                                Arrows()
                                Arrows()
                                    .rotationEffect(.degrees(180))
                            }
                            .rotationEffect(.degrees(-45))
                            .allowsHitTesting(false)
                        }
                    }
                    .overlay {
                        if isSuccess {
                            ConfettiView()
                        }
                    }
                
                Text(isSuccess ? "성공!\n" : isFail ? "두 손가락을 동시에\n움직여보세요!" : "두 손가락을 이용해서\n확대해볼까요?")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                HelpButton(style: isFail ? .primary : .secondary) {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
                .frame(maxHeight: .infinity, alignment: .bottom)
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
    }
    
    private var gesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                withAnimation {
                    isTapped = true
                    self.scale = min(max(value.magnitude, 0.8), 2.5)
                }
            }
            .onEnded { _ in
                withAnimation {
                    if scale > 1.2 {
                        isSuccess = true
                        self.scale = 2
                    } else {
                        isFail = true
                    }
                }
            }
    }
}

struct PinchPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        PinchPracticeView1()
    }
}
