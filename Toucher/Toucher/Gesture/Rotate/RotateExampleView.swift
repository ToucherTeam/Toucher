//
//  RotateExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct RotateExampleView: View {
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isFail = false
    @State private var navigate = false
    
    @State private var currentAmount: Angle = .degrees(0)
    @State private var accumulateAngle: Angle = .degrees(0)
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "회전하기")

                Text(isSuccess ? "잘하셨어요!\n" : isFail ? "두 손가락을 동시에\n움직여보세요!" : "두 손가락을 원 위에 대고\n회전시켜볼까요?")
                    .foregroundColor(isFail && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                Image("ToucherCharacter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 168)
                    .matchedGeometryEffect(id: "ch", in: namespace)
                    .frame(width: 400, height: 400)
                    .contentShape(Rectangle())
                    .frame(maxHeight: .infinity)
                    .rotationEffect(
                        isSuccess ?
                        .degrees(accumulateAngle.degrees > 45 ? 0 : -360) :
                        .degrees(-180) + accumulateAngle + currentAmount
                    )
                    .gesture(gesture)
                    .onTapGesture {
                        withAnimation {
                            isFail = true
                        }
                    }
                    .overlay {
                        if isSuccess {
                            ConfettiView()
                        }
                    }
                    .overlay {
                        if !isTapped || isFail && !isSuccess && !isTapped {
                            Image("rotation_guide")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 330, height: 330)
                                .allowsHitTesting(false)
                        }
                    }
                
                HelpButton(style: isFail ? .primary : .secondary) {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
            }
        }
        .allowsHitTesting(!isSuccess)
        .onChange(of: isSuccess) { _ in
            if isSuccess {
                HapticManager.notification(type: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    navigate = true
                }
            }
        }
        .navigationDestination(isPresented: $navigate) {
            RotationPracticeView()
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
        currentAmount = .zero
        accumulateAngle = .zero
    }
    
    private var gesture: some Gesture {
        RotationGesture()
            .onChanged { angle in
                currentAmount = angle
                withAnimation {
                    isTapped = true
                }
            }
            .onEnded { _ in
                accumulateAngle += currentAmount
                currentAmount = .zero
                
                if accumulateAngle.degrees < -45 || accumulateAngle.degrees > 45 {
                    withAnimation {
                        isSuccess = true
                    }
                } else {
                    print(accumulateAngle.degrees)
                    isSuccess = false
                    isFail = true
                }
            }
    }
}

struct RotateExampleView_Previews: PreviewProvider {
    static var previews: some View {
        RotateExampleView()
    }
}
