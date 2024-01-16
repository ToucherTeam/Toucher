//
//  PinchIconZoomInView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchIconZoomInView: View {
    @StateObject private var pinchVM = PinchViewModel()
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            if pinchVM.isFail && !pinchVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            if !pinchVM.isNavigate {
                VStack {
                    CustomToolbar(title: "확대 축소하기", isSuccess: pinchVM.isSuccess)
                    
                    ZStack {
                        VStack {
                            Text(pinchVM.isSuccess ? "성공!\n" : pinchVM.isFail ? "두 손가락을 동시에\n움직여보세요!" : "두 손가락을 원 위에 대고\n벌려보세요")
                                .foregroundColor(pinchVM.isFail && !pinchVM.isSuccess ? .white : .primary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(10)
                                .font(.customTitle)
                                .padding(.top, 40)
                                .padding(.horizontal)
                            
                            Spacer()
                            
                            HelpButton(style: pinchVM.isFail ? .primary : .secondary, currentViewName: "PinchExampleView1")
                                .opacity(pinchVM.isSuccess ? 0 : 1)
                                .animation(.easeInOut, value: pinchVM.isSuccess)
                        }
                        Image("ToucherCharacter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .scaleEffect(scale)
                            .frame(width: 320, height: 320)
                            .contentShape(Rectangle())
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
                    }
                }
            }
            if pinchVM.isNavigate {
                PinchIconZoomOutView()
            }
        }
    }
    
    private var gesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                withAnimation {
                    pinchVM.isTapped = true
                    self.scale = min(max(value.magnitude, 1), 2.5)
                }
            }
            .onEnded { _ in
                withAnimation {
                    if scale > 1.5 {
                        pinchVM.isSuccess = true
                        HapticManager.notification(type: .success)
                        self.scale = 2
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            pinchVM.isNavigate = true
                        }
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
    PinchIconZoomInView()
        .environment(\.locale, .init(identifier: "en"))
}
