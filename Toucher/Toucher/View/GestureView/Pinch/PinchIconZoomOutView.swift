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
    
    private let selectedGuideVideo: URLManager = .pinchIconZoomOutView
    
    var body: some View {
        ZStack {
            BackGroundColor(isFail: pinchVM.isFail, isSuccess: pinchVM.isSuccess)
            
            VStack {
                CustomToolbar(title: "확대 축소하기", isSuccess: pinchVM.isSuccess)
                
                ZStack {
                    VStack {
                        Text(pinchVM.isSuccess ? "성공!\n" : pinchVM.isFail ? "두 손가락을 동시에\n움직여보세요!" : "이번엔 크기를 작게\n만들어 볼까요?")
                            .foregroundColor(pinchVM.isFail && !pinchVM.isSuccess ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .font(.customTitle)
                            .padding(.top, 40)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        HelpButton(selectedGuideVideo: selectedGuideVideo, style: pinchVM.isFail ? .primary : .secondary)
                            .opacity(pinchVM.isSuccess ? 0 : 1)
                            .animation(.easeInOut, value: pinchVM.isSuccess)
                    }
                    
                    Image("ToucherCharacter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160)
                        .scaleEffect(scale)
                        .frame(width: 360, height: 320)
                        .contentShape(Rectangle())
                        .gesture(gesture)
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
                }
            }
            .modifier(MoveToNextModifier(isNavigate: $pinchVM.isNavigate, isSuccess: $pinchVM.isSuccess))
            .navigationDestination(isPresented: $pinchVM.isNavigate) {
                PinchImageView()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .modifier(
                FirebaseViewModifier(
                    isSuccess: pinchVM.isSuccess,
                    viewName: .pinchIconZoomOutView
                )
            )
            .onAppear {
                pinchVM.reset()
                scale = 1
            }
        }
        .analyticsScreen(name: "PinchIconZoomOutView")
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
                        AnalyticsManager.shared.logEvent(name: "PinchIconZoomOutView_Success")
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
                        FirestoreManager.shared.updateViewTapNumber(.pinch, .pinchIconZoomOutView)
                        AnalyticsManager.shared.logEvent(name: "PinchIconZoomOutView_Fail")
                    }
            )
            .simultaneously(
                with: DragGesture()
                    .onEnded { _ in
                        withAnimation {
                            pinchVM.isFail = true
                        }
                        AnalyticsManager.shared.logEvent(name: "PinchIconZoomOutView_Fail")
                    }
            )
    }
}

#Preview {
    PinchIconZoomOutView()
        .environment(\.locale, .init(identifier: "ko"))
}
