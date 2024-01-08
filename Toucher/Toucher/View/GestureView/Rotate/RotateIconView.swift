//
//  RotateIconView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct RotateIconView: View {
    @StateObject private var rotateVM = RotateViewModel()
    
    @State private var currentAmount: Angle = .degrees(0)
    @State private var accumulateAngle: Angle = .degrees(0)
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if rotateVM.isFail && !rotateVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "회전하기", isSuccess: rotateVM.isSuccess)

                Text(rotateVM.isSuccess ? "성공!\n" : rotateVM.isFail ? "두 손가락을 동시에\n움직여보세요!" : "두 손가락을 원 위에 대고\n회전시켜볼까요?")
                    .foregroundColor(rotateVM.isFail && !rotateVM.isSuccess ? .white : .primary)
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
                        rotateVM.isSuccess ?
                        .degrees(accumulateAngle.degrees > 45 ? 0 : -360) :
                        .degrees(-180) + accumulateAngle + currentAmount
                    )
                    .gesture(gesture)
                    .onTapGesture {
                        withAnimation {
                            rotateVM.isFail = true
                        }
                    }
                    .overlay {
                        if rotateVM.isSuccess {
                            ConfettiView()
                        }
                    }
                    .overlay {
                        if !rotateVM.isTapped || rotateVM.isFail && !rotateVM.isSuccess && !rotateVM.isTapped {
                            Image("rotation_guide")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 330, height: 330)
                                .allowsHitTesting(false)
                        }
                    }
                
                HelpButton(style: rotateVM.isFail ? .primary : .secondary, currentViewName: "RotateExampleView")
                .opacity(rotateVM.isSuccess ? 0 : 1)
                .animation(.easeInOut, value: rotateVM.isSuccess)
            }
        }
        .modifier(MoveToNextModifier(isNavigate: $rotateVM.isNavigate, isSuccess: $rotateVM.isSuccess))
        .navigationDestination(isPresented: $rotateVM.isNavigate) {
            RotateMapView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            rotateVM.reset()
            currentAmount = .zero
            accumulateAngle = .zero
        }
    }
    
    private var gesture: some Gesture {
        RotationGesture()
            .onChanged { angle in
                currentAmount = angle
                withAnimation {
                    rotateVM.isTapped = true
                }
            }
            .onEnded { _ in
                accumulateAngle += currentAmount
                currentAmount = .zero
                
                if accumulateAngle.degrees < -45 || accumulateAngle.degrees > 45 {
                    withAnimation {
                        rotateVM.isSuccess = true
                    }
                } else {
                    print(accumulateAngle.degrees)
                    rotateVM.isSuccess = false
                    rotateVM.isFail = true
                }
            }
    }
}

struct RotateExampleView_Previews: PreviewProvider {
    static var previews: some View {
        RotateIconView()
    }
}
