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
    @State private var isOneTapped = false
    
    @State private var currentAmount = Angle.degrees(0)
    @State private var accumulateAngle: Angle = .degrees(0)
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if isOneTapped && !isSuccess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                Text(isSuccess ? "잘하셨어요!\n" : isOneTapped ? "두 손가락을 동시에\n움직여보세요!" : "두 손가락을 원 위에 대고\n회전시켜볼까요?")
                    .foregroundColor(isOneTapped && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                Image("ch_default")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 168)
                    .matchedGeometryEffect(id: "ch", in: namespace)
                    .background {
                        Circle()
                            .frame(width: 400)
                            .foregroundColor(isOneTapped ? .clear : Color(UIColor.systemBackground))
                    }
                    .frame(maxHeight: .infinity)
                    .rotationEffect(
                        isSuccess ?
                        .degrees(accumulateAngle.degrees > 45 ? 0 : -360) :
                        .degrees(-180) + accumulateAngle + currentAmount
                    )
                    .gesture(
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
                                    isOneTapped = true
                                }
                            })
                    .onTapGesture {
                        withAnimation {
                            isOneTapped = true
                        }
                    }
                    .overlay {
                        if !isTapped {
                            Image("rotation_guide")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 330, height: 330)
                                .allowsHitTesting(false)
                        }
                    }
                Group {
                    Text("화면의 물체를")
                    + Text(" 뒤집어 보고")
                        .bold()
                    + Text("\n싶을 때 사용해요.")
                }
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .foregroundColor(isTapped || isOneTapped ? .clear : .gray)
                .font(.title)
                .padding(.bottom, 80)
            }
            
            if isSuccess {
                ToucherNavigationLink {
                    RotationPracticeView()
                }
            }
        }
        .onAppear {
            isTapped = false
            isSuccess = false
            isOneTapped = false
            currentAmount = .zero
            accumulateAngle = .zero
        }
    }
}

struct RotateExampleView_Previews: PreviewProvider {
    static var previews: some View {
        RotateExampleView()
    }
}
