//
//  PinchPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchPracticeView1: View {
    @State private var isSuceess = false
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
                                self.scale = min(max(value.magnitude, 0.8), 2.5)
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                if scale > 1.2 {
                                    isSuceess = true
                                    self.scale = 2
                                }
                            }
                        }
                )
            Text(isSuceess ? "잘하셨어요!\n" : "두 손가락을 이용해서\n확대해볼까요?")
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct PinchPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        PinchPracticeView1()
    }
}
