//
//  RotationPracticeView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI
import MapKit

struct RotationPracticeView: View {
    @StateObject private var navigationManager = NavigationManager.shared

    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isOneTapped = false
    
    @State private var currentAmount = Angle.degrees(0)
    @State private var accumulateAngle: Angle = .degrees(0)
    
    @State private var heading: CLLocationDirection = 0
    
    @Namespace var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            CustomToolbar(title: "회전하기")
                .zIndex(1)

            ZStack {
                RotationMap(heading: $heading)
                    .ignoresSafeArea()
                    .gesture(
                        RotationGesture()
                            .onChanged { angle in
                                withAnimation {
                                    heading = CLLocationDirection(-angle.degrees)
                                }
                            }
                    )
                    .onChange(of: heading) { _ in
                        if abs(heading) > 10 {
                            isSuccess = true
                        }
                    }
                    .overlay {
                        if isSuccess {
                            ConfettiView()
                        }
                    }
                
                Text(isSuccess ? "성공!" : "지도를 회전시켜 볼까요?")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
                    .background {
                        Rectangle()
                            .foregroundColor(.customWhite.opacity(0.7))
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .allowsHitTesting(!isSuccess)
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
        isOneTapped = false
    }
}

struct RotationPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        RotationPracticeView()
    }
}
