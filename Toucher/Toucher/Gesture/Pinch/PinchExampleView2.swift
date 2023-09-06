//
//  PinchExampleView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchExampleView2: View {
    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var scale: CGFloat = 1
    
    var body: some View {
        VStack {
            Text(isSuceess ? "잘하셨어요!\n" : "이번엔 크기를 작게\n만들어 볼까요?")
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
            
            Image("ch_default")
                .resizable()
                .scaledToFit()
                .frame(width: 160)
                .scaleEffect(scale)
                .background {
                    Rectangle()
                        .frame(width: 360, height: 360)
                        .foregroundColor(Color(UIColor.systemBackground))
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            withAnimation {
                                isTapped = true
                                self.scale = min(max(value.magnitude, 0.25), 1.5)
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                if scale < 0.8 {
                                    isSuceess = true
                                    self.scale = 0.6
                                }
                            }
                        }
                )
                .frame(maxHeight: .infinity)
                .overlay {
                    if !isTapped {
                        HStack(spacing: 100) {
                            Arrows()
                                .rotationEffect(.degrees(180))
                            Arrows()
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
            .foregroundColor(.clear)
            .font(.title)
            .padding(.bottom, 80)

        }
    }
}

struct PinchExampleView2_Previews: PreviewProvider {
    static var previews: some View {
        PinchExampleView2()
    }
}
