//
//  PracticeBubble.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

struct PracticeBubble: View {
    @State private var bubbleAnimation = false
    
    var gesture: GestureType
    var action: () -> Void
    
    var practiceNum: String {
        switch gesture {
        case .doubleTap:
            "학습 1"
        case .longPress:
            "학습 2"
        case .swipe:
            "학습 3"
        case .drag:
            "학습 4"
        case .pan:
            "학습 5"
        case .pinch:
            "학습 6"
        case .rotate:
            "학습 7"
        }
    }
    var title: String {
        switch gesture {
        case .doubleTap:
            "두번 누르기"
        case .longPress:
            "길게 누르기"
        case .swipe:
            "살짝 쓸기"
        case .drag:
            "끌어오기"
        case .pan:
            "화면 움직이기"
        case .pinch:
            "확대 축소하기"
        case .rotate:
            "회전하기"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Polygon()
                .frame(width: 30, height: 15)
                .foregroundColor(.customBG0)
                .shadow(color: .customShadow.opacity(0.5), radius: 2, y: -4)
                .offset(y: 2)
                .zIndex(1)
            VStack(alignment: .leading) {
                HStack {
                    Text(practiceNum)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    Text(title)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                }
                .foregroundColor(.customPrimary)
                .padding(.bottom)
                
                Button {
                    action()
                } label: {
                    Text("시작하기")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.customWhite)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                        }
                }
            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.customBG0)
                    .shadow(color: .customShadow, radius: 10, y: 4)
            }
            .padding(.horizontal)
        }
        .offset(y: bubbleAnimation ? -3 : 3)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                bubbleAnimation = true
            }
        }
    }
}

struct Polygon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.59041*width, y: 0.10108*height))
        path.addCurve(
            to: CGPoint(x: 0.40959*width, y: 0.10108*height),
            control1: CGPoint(x: 0.54229*width, y: -0.00395*height),
            control2: CGPoint(x: 0.45771*width, y: -0.00395*height)
        )
        path.addLine(to: CGPoint(x: 0.01613*width, y: 0.95981*height))
        path.addLine(to: CGPoint(x: 0.98387*width, y: 0.95981*height))
        path.addLine(to: CGPoint(x: 0.59041*width, y: 0.10108*height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        Color.customBG1.ignoresSafeArea()
        PracticeBubble(gesture: .doubleTap) {
            
        }
    }
}
