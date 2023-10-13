//
//  PinchPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchPracticeView1: View {
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            Image("ex_image")
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            withAnimation {
                                isTapped = true
                                self.scale = min(max(value.magnitude, 0.8), 2.5)
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                if scale > 1.2 {
                                    isSuccess = true
                                    self.scale = 2
                                }
                            }
                        }
                )
                .overlay {
                    if !isTapped {
                        HStack(spacing: 100) {
                            Arrows()
                            Arrows()
                                .rotationEffect(.degrees(180))
                        }
                        .rotationEffect(.degrees(-45))
                        .allowsHitTesting(false)
                    }
                }
            
            Text(isSuccess ? "잘하셨어요!\n" : "두 손가락을 이용해서\n확대해볼까요?")
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
                .frame(maxHeight: .infinity, alignment: .top)
            
            if isSuccess {
                ToucherNavigationLink(label: "완료") {
                    FinalView(gestureTitle: "확대 축소하기")
                        .padding(.bottom, 13)
                        .overlay(
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(Color("GR3")),
                            alignment: .top
                        )
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                CustomToolbar(title: "확대 축소하기")
                            }
                        }
                    
                }
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
                CustomToolbar(title: "확대 축소하기")
            }
        }

    }
}

struct PinchPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        PinchPracticeView1()
    }
}
