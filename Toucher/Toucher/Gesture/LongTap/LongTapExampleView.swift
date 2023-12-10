//
//  LongTapExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapExampleView: View {
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isOneTapped = false
    
    @State private var isPressed = false
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            if isOneTapped && !isSuccess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                Text(isSuccess ? "잘하셨어요!\n" : isOneTapped ? "조금 더 길게 꾹 \n눌러주세요!" : "1초동안 길게\n눌러볼까요?")
                    .foregroundColor(isOneTapped && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                Image(isSuccess ? "ch_button_pressed" : "ch_button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 184)
                    .frame(maxHeight: .infinity)
                    .background {
                        ZStack {
                            Circle()
                                .frame(width: 184)
                                .foregroundColor(.customBG2)
                            Circle()
                                .frame(width: 144)
                                .foregroundColor(.customSecondary)
                        }
                        .scaleEffect(isPressed ? 1.6 : 1)
                        .opacity(isSuccess ? 0 : 1)
                        .animation(.easeInOut(duration: 1), value: isPressed)
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 1)
                            .onChanged { _ in
                                isTapped = true
                                isPressed = true
                                timer?.invalidate() // 이미 진행 중인 타이머를 무효화합니다.
                                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                    isPressed = false
                                    isOneTapped = true
                                }
                            }
                            .onEnded { _ in
                                timer?.invalidate() // 무효화합니다.
                                if !isPressed { // 1초 이하로 눌렀을 때
                                    isPressed = false
                                } else {
                                    withAnimation {
                                        isSuccess = true
                                    }
                                }
                            }
                            .simultaneously(with: TapGesture()
                                .onEnded {
                                    withAnimation {
                                        isTapped = true
                                        isOneTapped = true
                                        isPressed = false
                                    }
                                })
                    )
                    Group {
                        Text("아이콘의 추가")
                            .bold()
                        + Text(" 기능과")
                        + Text("\n미리보기")
                            .bold()
                        + Text("기능을 볼 때 사용해요.")
                    }
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .foregroundColor(isTapped ? .clear : .gray)
                    .font(.title)
                    .padding(.bottom, 80)
            }
            if isSuccess {
                ToucherNavigationLink {
                    LongTapPracticeView1()
                }
            }

        }

        .onAppear {
            isTapped = false
            isSuccess = false
            isOneTapped = false
            isPressed = false
        }
    }
}

struct LongTapExampleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LongTapExampleView()
        }
    }
}
