//
//  LongTapPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapPracticeView1: View {
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
                Text(isSuceess ? "잘하셨어요!\n\n" : isOneTapped ? "조금 더 길게 꾹 \n눌러주세요!\n" : "카메라를 1초 동안\n눌러서 추가 기능을\n알아볼까요?")
                    .foregroundColor(isOneTapped && !isSuceess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                Spacer()
                Image("Camera")
                    .resizable()
                    .frame(width: 130, height: 130)
                    .foregroundStyle(.gray)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(isPressed ? .black.opacity(0.5) : .clear)
                    }
                    .scaleEffect(isPressed ? 1.1 : 1)
                    .animation(.easeInOut(duration: 1), value: isPressed)
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
                    .background(alignment: .bottomTrailing) {
                        if isSuceess {
                            VStack {
                                Group {
                                    HStack {
                                        Text("셀피 찍기")
                                        Spacer()
                                        Image(systemName: "person.crop.square")
                                    }
                                    Divider()
                                    HStack {
                                        Text("비디오 녹화")
                                        Spacer()
                                        Image(systemName: "person.and.background.dotted")
                                    }
                                    Divider()
                                    HStack {
                                        Text("인물 사진 찍기")
                                        Spacer()
                                        Image(systemName: "person.and.background.dotted")
                                    }
                                    Divider()
                                    HStack {
                                        Text("인물 사진 셀피 찍기")
                                        Spacer()
                                        Image(systemName: "doc.on.doc")
                                    }
                                }
                                Rectangle()
                                    .frame(width: 250, height: 8)
                                    .foregroundColor(Color(.systemGray4))
                                HStack {
                                    Text("홈 화면 편집")
                                    Spacer()
                                    Image(systemName: "apps.iphone")
                                }
                                Divider()
                                HStack {
                                    Text("앱 제거")
                                    Spacer()
                                    Image(systemName: "minus.circle")
                                }
                                .foregroundColor(.red)
                            }
                            .padding(10)
                            .frame(width: 250)
                            .background {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .foregroundStyle(Color(.systemGray5))
                            }
                            .offset(y: 270)
                            .transition(.scale)
                        }
                    }
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            if isSuceess {
                ToucherNavigationLink {
                    LongTapPracticeView2()
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
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .onAppear {
            isTapped = false
            isSuceess = false
            isOneTapped = false
        }
    }
}

struct LongTapPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        LongTapPracticeView1()
    }
}
