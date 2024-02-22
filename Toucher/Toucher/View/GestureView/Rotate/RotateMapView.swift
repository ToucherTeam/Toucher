//
//  RotateMapView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI
import MapKit

struct RotateMapView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    @StateObject private var rotateVM = RotateViewModel()
    
    @State private var currentAmount = Angle.degrees(0)
    @State private var accumulateAngle: Angle = .degrees(0)
    @State private var heading: CLLocationDirection = 0
    
    @Namespace var namespace
    
    private let selectedGuideVideo: URLManager = .rotateMapView
    
    var body: some View {
        VStack(spacing: 0) {
            CustomToolbar(title: "회전하기", isSuccess: rotateVM.isSuccess)
                .zIndex(1)
            
            ZStack {
                RotateMap(heading: $heading)
                    .ignoresSafeArea()
                    .gesture(
                        RotationGesture()
                            .onChanged { angle in
                                withAnimation {
                                    heading = CLLocationDirection(-angle.degrees)
                                }
                            }
                            .exclusively(
                                before: TapGesture()
                                    .onEnded {
                                        withAnimation {
                                            rotateVM.isFail = true
                                        }
                                        FirestoreManager.shared.updateViewTapNumber(.rotate, .rotateMapView)
                                        AnalyticsManager.shared.logEvent(name: "RotateMapView_Fail")
                                    })

                    )
                    .onChange(of: heading) { _ in
                        if abs(heading) > 10 {
                            rotateVM.isSuccess = true
                            AnalyticsManager.shared.logEvent(name: "RotateMapView_Fail")
                        }
                    }
                    .overlay {
                        if rotateVM.isSuccess {
                            ConfettiView()
                        }
                    }
                
                Text(rotateVM.isSuccess ? "성공!" : "지도를 회전시켜 볼까요?")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.vertical, 40)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background {
                        Rectangle()
                            .foregroundColor(.customWhite.opacity(0.7))
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                
                HelpButton(selectedGuideVideo: selectedGuideVideo, style: rotateVM.isFail ? .primary : .secondary)
                    .opacity(rotateVM.isSuccess ? 0 : 1)
                    .animation(.easeInOut, value: rotateVM.isSuccess)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .analyticsScreen(name: "RotateMapView")
        .modifier(FinishModifier(isNavigate: $rotateVM.isNavigate, isSuccess: $rotateVM.isSuccess))
        .modifier(
            FirebaseEndViewModifier(
                isSuccess: rotateVM.isSuccess,
                viewName: .rotateMapView
            )
        )
        .onAppear {
            rotateVM.reset()
        }
    }
}

#Preview {
    RotateMapView()
        .environment(\.locale, .init(identifier: "ja"))
}
