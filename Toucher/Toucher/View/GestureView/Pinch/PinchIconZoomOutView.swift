//
//  PinchIconZoomOutView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchIconZoomOutView: View {
    @StateObject private var pinchVM = PinchViewModel()
    
    @State private var scale: CGFloat = 1
    
    var body: some View {
        ZStack {
            if pinchVM.isFail && !pinchVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            
            VStack {
                CustomToolbar(title: "확대 축소하기", isSuccess: pinchVM.isSuccess)
                
                Text(pinchVM.isSuccess ? "성공!\n" : pinchVM.isFail ? "두 손가락을 동시에\n움직여보세요!" : "이번엔 크기를 작게\n만들어 볼까요?")
                    .foregroundColor(pinchVM.isFail && !pinchVM.isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                
                Image("ToucherCharacter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160)
                    .scaleEffect(scale)
                    .frame(width: 360, height: 320)
                    .contentShape(Rectangle())
                    .gesture(gesture)
                    .frame(maxHeight: .infinity)
                    .overlay {
                        if !pinchVM.isTapped || pinchVM.isFail && !pinchVM.isSuccess {
                            HStack(spacing: 100) {
                                Arrows(arrowColor: .customBG1)
                                    .rotationEffect(.degrees(180))
                                Arrows(arrowColor: .customBG1)
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
                
                HelpButton(style: pinchVM.isFail ? .primary : .secondary, currentViewName: "PinchExampleView2")
                    .opacity(pinchVM.isSuccess ? 0 : 1)
                    .animation(.easeInOut, value: pinchVM.isSuccess)
            }
        }
        .modifier(MoveToNextModifier(isNavigate: $pinchVM.isNavigate, isSuccess: $pinchVM.isSuccess))
        .navigationDestination(isPresented: $pinchVM.isNavigate) {
            PinchImageView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            pinchVM.reset()
            scale = 1
        }
    }
    
    private var gesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                withAnimation {
                    pinchVM.isTapped = true
                    self.scale = min(max(value.magnitude, 0.25), 1.5)
                }
            }
            .onEnded { _ in
                withAnimation {
                    if scale < 0.8 {
                        pinchVM.isSuccess = true
                        self.scale = 0.6
                    }
                }
            }
            .simultaneously(
                with: TapGesture()
                    .onEnded { _ in
                        withAnimation {
                            pinchVM.isFail = true
                        }
                    }
            )
            .simultaneously(
                with: DragGesture()
                    .onEnded { _ in
                        withAnimation {
                            pinchVM.isFail = true
                        }
                    }
            )
    }
}

#Preview {
    PinchIconZoomOutView()
}
