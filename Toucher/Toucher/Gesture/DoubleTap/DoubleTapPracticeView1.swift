//
//  DoubleTapPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapPracticeView1: View {
    
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isOneTapped = false
    
    var body: some View {
        
        ZStack {
            if isOneTapped && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "두 번 누르기")
                
                Text(isSuccess ? "잘하셨어요!\n" : isOneTapped ? "조금만 더 빠르게\n두 번 눌러주세요!" : "검색창을 두 번\n눌러볼까요?")
                    .foregroundColor(isOneTapped && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("검색")
                    Spacer()
                    Image(systemName: "mic.fill")
                }
                .overlay(
                    Image("paste_bar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: isSuccess ? 600 : 0, height: 50)
                        .offset(x: -20, y: -45)
                )
                .font(.title)
                .foregroundColor(.secondary)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .foregroundStyle(Color(.systemGray5).opacity(0.8))
                }
                .padding()
                .frame(maxHeight: .infinity)
                .gesture(
                    TapGesture(count: 2)
                        .onEnded {
                            withAnimation {
                                isSuccess = true
                                isTapped = true
                            }
                        }
                        .exclusively(
                            before: TapGesture()
                                .onEnded {
                                    withAnimation {
                                        isTapped = true
                                        isOneTapped = true
                                    }
                                })
                )
                
                Group {
                    Text("사진을 확대/축소")
                        .bold()
                    + Text(" 할 때,")
                    + Text("\n글자를 수정")
                        .bold()
                    + Text("할 때 사용해요.")
                }
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .foregroundColor(.clear)
                .font(.title)
                .padding(.bottom, 80)
            }
            if isSuccess {
                ToucherNavigationLink {
                    DoubleTapPracticeView2()
                }
            }
        }
        .onAppear {
            isTapped = false
            isSuccess = false
            isOneTapped = false
        }
    }
}

struct DoubleTapPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTapPracticeView1()
    }
}
