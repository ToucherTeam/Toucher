//
//  PanExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PanExampleView: View {
    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var isOneTapped = false
    
    @GestureState private var isPressed = false
    
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            if isOneTapped && !isSuceess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                Text(isSuceess ? "잘하셨어요!\n" : "밑에서 위로\n쓸어 올려보세요.")
                    .foregroundColor(isOneTapped && !isSuceess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                
                ScrollView {
                    Color.clear
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(key: OffsetPreferenceKey.self, value: proxy.frame(in: .global).minY)
                            }
                        )
                        .onPreferenceChange(OffsetPreferenceKey.self) { minY in
                            // 추가: ScrollView의 오프셋이 변경될 때 호출되는 핸들러
                            scrollOffset = minY
                            isSuceess = true
                            withAnimation(.easeInOut) {
                                isTapped = true
                            }
                        }
                    notification1
                    notification2(title: "1588", message: "(광고) 안녕하세요")
                    notification2(title: "114", message: "[Web 발신] 안녕하세요")
                    notification1
                }
                .frame(maxHeight: .infinity)
                .padding(.vertical, 70)
                .overlay {
                    if !isTapped {
                        Arrows()
                            .rotationEffect(.degrees(90))
                    }
                }
                
                Group {
                    Text("현재 ")
                    + Text("화면을 상하좌우로")
                        .bold()
                    + Text("\n움직일 때 사용해요.")
                }
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .foregroundColor(isTapped ? .clear : .gray)
                .font(.title)
                .padding(.bottom, 80)
            }
            
        }
        .onAppear {
            isTapped = false
            isSuceess = false
            isOneTapped = false
        }
    }
    
    @ViewBuilder
    private var notification1: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.black, .yellow)
                .padding(.leading)
            VStack(alignment: .leading) {
                Text("긴급재난문자")
                    .bold()
                Text("[중앙재난안전대책본부] 안녕하세요")
            }
            Spacer()
        }
        .frame(height: 66)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .foregroundColor(Color(.systemGray5))
        }
        .padding(.horizontal, 14)
    }
    
    @ViewBuilder
    private func notification2(title: String, message: String) -> some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.white, .gray)
                .padding(.leading)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .foregroundColor(.green)
                                .frame(width: 16, height: 16)
                        }
                }
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                Text(message)
            }
            Spacer()
        }
        .frame(height: 66)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .foregroundColor(Color(.systemGray5))
        }
        .padding(.horizontal, 14)
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct PanExampleView_Previews: PreviewProvider {
    static var previews: some View {
        PanExampleView()
    }
}
