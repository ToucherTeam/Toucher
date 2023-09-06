//
//  RotateExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct RotateExampleView: View {
    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var isOneTapped = false
    
    @State private var currentAmount = Angle.degrees(0)
    
    @Namespace var namespace
        
    var body: some View {
        ZStack {
            if isOneTapped && !isSuceess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                Text(isSuceess ? "잘하셨어요!\n" : "두 손가락을 원 위에 대고\n회전시켜볼까요?")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                if isSuceess {
                    Image("ch_default")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 168)
                        .frame(maxHeight: .infinity)
                } else {
                    Image("ch_default")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 168)
                        .frame(maxHeight: .infinity)
                        .rotationEffect(.degrees(-180) + currentAmount)
                        .gesture(
                            RotationGesture()
                                .onChanged { angle in
                                    currentAmount = angle
                                    withAnimation {
                                        isTapped = true
                                    }
                                }
                                .onEnded {_ in
                                    if currentAmount.degrees < -150 || currentAmount.degrees > 150 {
                                        withAnimation {
                                            isSuceess = true
                                        }
                                    } else {
                                        print(currentAmount.degrees)
                                        isSuceess = false
                                    }
                                })
                }
                Group {
                    Text("화면의 물체를")
                    + Text(" 뒤집어 보고")
                        .bold()
                    + Text("\n싶을 때 사용해요.")
                }
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .foregroundColor(isTapped ? .clear : .gray)
                .font(.title)
                .padding(.bottom, 80)
            }
            
            if isSuceess {
                ToucherNavigationLink {
                    RotationPracticeView()
                }
            }
        }
        .onAppear {
            isTapped = false
            isSuceess = false
            isOneTapped = false
            currentAmount = .degrees(0)
        }
    }
}

struct RotateExampleView_Previews: PreviewProvider {
    static var previews: some View {
        RotateExampleView()
    }
}
