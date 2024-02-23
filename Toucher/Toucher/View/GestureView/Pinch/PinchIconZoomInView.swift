//
//  PinchIconZoomInView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchIconZoomInView: View {
    @AppStorage("createPinch") var createPinch = true
    @StateObject private var pinchVM = PinchViewModel()
    
    @State private var scale: CGFloat = 1.0
    
    private let selectedGuideVideo: URLManager = .pinchIconZoomInView
    
    var body: some View {
        ZStack {
            BackGroundColor(isFail: pinchVM.isFail, isSuccess: pinchVM.isSuccess)
            
            if !pinchVM.isNavigate {
                VStack {
                    CustomToolbar(title: "확대 축소하기", isSuccess: pinchVM.isSuccess, selectedGuideVideo: selectedGuideVideo)
                    
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
                            
                            HelpButton(selectedGuideVideo: selectedGuideVideo, style: pinchVM.isFail ? .primary : .secondary)
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
                    .modifier(
                        FirebaseStartViewModifier(
                            create: $createPinch,
                            isSuccess: pinchVM.isSuccess,
                            viewName: .pinchIconZoomInView
                        )
                    )
                }
            }
            if pinchVM.isNavigate {
                PinchIconZoomOutView()
            }
        }
        .analyticsScreen(name: "PinchIconZoomInView")
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
                        AnalyticsManager.shared.logEvent(name: "PinchIconZoomInView_ClearCount")
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
                        FirestoreManager.shared.updateViewTapNumber(.pinch, .pinchIconZoomInView)
                        AnalyticsManager.shared.logEvent(name: "PinchIconZoomInView_Fail")
                    }
            )
            .simultaneously(
                with: DragGesture()
                    .onEnded { _ in
                        withAnimation {
                            pinchVM.isFail = true
                        }
                        AnalyticsManager.shared.logEvent(name: "PinchIconZoomInView_Fail")
                    }
            )
    }
}

#Preview {
    PinchIconZoomInView()
        .environment(\.locale, .init(identifier: "en"))
}
