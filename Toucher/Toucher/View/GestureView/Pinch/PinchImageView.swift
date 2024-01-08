//
//  PinchImageView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchImageView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    @StateObject private var pinchVM = PinchViewModel()

    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            CustomToolbar(title: "확대 축소하기", isSuccess: pinchVM.isSuccess)
                .zIndex(1)

            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                Image("ex_image")
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(scale)
                    .gesture(gesture)
                    .overlay {
                        if !pinchVM.isTapped || pinchVM.isFail && !pinchVM.isSuccess {
                            HStack(spacing: 100) {
                                Arrows(arrowColor: .customBG1)
                                Arrows(arrowColor: .customBG1)
                                    .rotationEffect(.degrees(180))
                            }
                            .rotationEffect(.degrees(-45))
                            .allowsHitTesting(false)
                        }
                    }
                    .overlay {
                        if pinchVM.isSuccess {
                            ConfettiView()
                        }
                    }
                
                Text(pinchVM.isSuccess ? "성공!\n" : pinchVM.isFail ? "두 손가락을 동시에\n움직여보세요!" : "두 손가락을 이용해서\n확대해볼까요?")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                HelpButton(style: pinchVM.isFail ? .primary : .secondary, currentViewName: "PinchPracticeView1")
                .opacity(pinchVM.isSuccess ? 0 : 1)
                .animation(.easeInOut, value: pinchVM.isSuccess)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .modifier(FinishModifier(isNavigate: $pinchVM.isNavigate, isSuccess: $pinchVM.isSuccess))
    }
    
    private var gesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                withAnimation {
                    pinchVM.isTapped = true
                    self.scale = min(max(value.magnitude, 0.8), 3)
                }
            }
            .onEnded { _ in
                withAnimation {
                    if scale > 1.2 {
                        pinchVM.isSuccess = true
                        self.scale = 3
                    } else {
                        pinchVM.isFail = true
                    }
                }
            }
    }
}

struct PinchPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        PinchImageView()
    }
}