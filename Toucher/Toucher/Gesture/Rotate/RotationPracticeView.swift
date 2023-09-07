//
//  RotationPracticeView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct RotationPracticeView: View {
    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var isOneTapped = false
    
    @State private var currentAmount = Angle.degrees(0)
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            Image("Map")
                .resizable()
                .scaledToFill()
                .frame(maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
                .rotationEffect(currentAmount)
                .gesture(
                    RotationGesture()
                        .onChanged { angle in
                            currentAmount = angle
                            withAnimation {
                                isTapped = true
                            }
                        }
                        .onEnded {_ in
                            if currentAmount.degrees < -30 || currentAmount.degrees > 30 {
                                withAnimation {
                                    isSuceess = true
                                }
                            } else {
                                print(currentAmount.degrees)
                                isSuceess = false
                            }
                        })
            Text(isSuceess ? "잘하셨어요!" : "지도를 회전시켜 볼까요?")
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
                .frame(maxHeight: .infinity, alignment: .top)
            
            if isSuceess {
                ToucherNavigationLink {
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
                                CustomToolbar()
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
                CustomToolbar()
            }
        }
        .onAppear {
            isTapped = false
            isSuceess = false
            isOneTapped = false
        }
    }
}

struct RotationPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        RotationPracticeView()
    }
}
