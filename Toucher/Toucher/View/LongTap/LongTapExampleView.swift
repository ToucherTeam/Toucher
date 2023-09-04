//
//  LongTapExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapExampleView: View {
    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var isOneTapped = false
    
    @GestureState private var isPressed = false
    
    var body: some View {
        ZStack {
            if isOneTapped && !isSuceess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                Text(isSuceess ? "잘하셨어요!\n" : isOneTapped ? "조금 더 길게 꾹 \n눌러주세요!" : "1초동안 길게\n눌러볼까요?")
                    .foregroundColor(isOneTapped && !isSuceess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                Image(isSuceess ? "ch_button_pressed" : "ch_button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 184)
                    .frame(maxHeight: .infinity)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .updating($isPressed) { value, gestureState, _ in
                                gestureState = value
                            }
                            .onEnded {_ in
                                withAnimation {
                                    isSuceess = true
                                    isTapped = true
                                }
                            }
                            .simultaneously(with: TapGesture()
                                    .onEnded {
                                        withAnimation {
                                            isTapped = true
                                            isOneTapped = true
                                        }
                                    })
                    )
                    .background {
                        ZStack {
                            Circle()
                                .frame(width: 184)
                                .foregroundColor(Color("Secondary_alert"))
                            Circle()
                                .frame(width: 144)
                                .foregroundColor(Color("Secondary"))
                        }
                        .scaleEffect(isPressed ? 1.6 : 1)
                        .opacity(isSuceess ? 0 : 1)
                        .animation(.easeInOut(duration: 1), value: isPressed)
                    }
                
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
            if isSuceess {
                NavigationLink {
                    
                } label: {
                    Text("다음")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                        }
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }

        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("길게 누르기")
            }
        }
        .onAppear {
            isTapped = false
            isSuceess = false
            isOneTapped = false
        }
    }
}

struct LongTapExampleView_Previews: PreviewProvider {
    static var previews: some View {
        LongTapExampleView()
    }
}
