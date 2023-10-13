//
//  RotationPracticeView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct RotationPracticeView: View {
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isOneTapped = false
    
    @State private var currentAmount = Angle.degrees(0)
    @State private var accumulateAngle: Angle = .degrees(0)
    
    @Namespace var namespace
    
    var body: some View {
            ZStack {
                Image("Map")
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.bottom)
                    .rotationEffect(accumulateAngle + currentAmount)
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
                                }
                            })
                GeometryReader { geometry in
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(alignment: .top) {
                            Text("")
                                .frame(height: geometry.safeAreaInsets.top)
                                .frame(maxWidth: .infinity)
                                .background {
                                    Color.white
                                }
                                .edgesIgnoringSafeArea(.top)
                        }
                }
                Text(isSuccess ? "잘하셨어요!" : "지도를 회전시켜 볼까요?")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                if isSuccess {
                    ToucherNavigationLink(label: "완료") {
                        FinalView(gestureTitle: "회전하기")
                            .padding(.bottom, 13)
                            .overlay(
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundColor(Color("GR3")),
                                alignment: .top
                            )
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    CustomToolbar(title: "회전하기")
                                }
                            }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width)
                }
            }
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color("GR3")),
                alignment: .top
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    CustomToolbar(title: "회전하기")
                }
            }
            .onAppear {
                isTapped = false
                isSuccess = false
                isOneTapped = false
            }
        }
    }
    
    struct RotationPracticeView_Previews: PreviewProvider {
        static var previews: some View {
            RotationPracticeView()
        }
    }
