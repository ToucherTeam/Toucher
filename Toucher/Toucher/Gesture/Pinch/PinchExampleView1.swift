//
//  PinchView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchExampleView1: View {
    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var isNextView = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            if !isNextView {
                VStack {
                    Text(isSuceess ? "잘하셨어요!\n" : "두 손가락을 원 위에 대고\n벌려보세요")
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 30)
                    
                    Image("ch_default")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .scaleEffect(scale)
                        .background {
                            Rectangle()
                                .frame(width: 320, height: 320)
                                .foregroundColor(Color(UIColor.systemBackground))
                        }
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    withAnimation {
                                        isTapped = true
                                        self.scale = min(max(value.magnitude, 1), 2.5)
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        if scale > 1.5 {
                                            isSuceess = true
                                            self.scale = 2
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                withAnimation(.easeInOut) {
                                                    isNextView = true
                                                }
                                            }
                                        }
                                    }
                                }
                        )
                        .frame(maxHeight: .infinity)
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
                    
                    Group {
                        Text("사진, 화면을")
                            .bold()
                        + Text("\n확대/축소할")
                            .bold()
                        + Text(" 때 사용해요.")
                    }
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .foregroundColor(isTapped ? .clear : .gray)
                    .font(.title)
                    .padding(.bottom, 80)
                    
                }
            }
            if isNextView {
                PinchExampleView2()
            }
        }
    }
}

struct PinchExampleView1_Previews: PreviewProvider {
    static var previews: some View {
        PinchExampleView1()
    }
}
