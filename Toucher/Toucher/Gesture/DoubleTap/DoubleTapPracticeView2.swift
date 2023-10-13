//
//  DoubleTapPracticeView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapPracticeView2: View {
    
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isOneTapped = false
    
    let UIWidth = UIScreen.main.bounds.width
    let UIHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            Image("ex_image")
                .resizable()
                .scaledToFit()
                .scaleEffect(isSuccess ? 2 : 1)
                .ignoresSafeArea()
                .gesture(
                    TapGesture(count: 2)
                        .onEnded {
                            withAnimation {
                                isSuccess.toggle()
                                isTapped = true
                            }
                        }
                        .exclusively(
                            before: TapGesture()
                                .onEnded {
                                    withAnimation {
                                        isTapped.toggle()
                                        isOneTapped = true
                                    }
                                })
                )
            
            Text(isSuccess ? "잘하셨어요!\n" : isOneTapped ? "조금만 더 빠르게 두 번\n눌러주세요!" : "빠르게 두 번 눌러\n사진을 확대해볼까요?")
                .foregroundColor(isOneTapped && !isSuccess ? .accentColor : .primary)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
                .frame(maxHeight: .infinity, alignment: .top)
            if isSuccess {
                ToucherNavigationLink(label: "완료") {
                    FinalView(gestureTitle: "두 번 누르기")
                        .padding(.bottom, 13)
                        .overlay(
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(Color("GR3")),
                            alignment: .top
                        )
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                CustomToolbar(title: "두 번 누르기")
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
                CustomToolbar(title: "두 번 누르기")
            }
        }
        .onAppear {
            isTapped = false
            isSuccess = false
            isOneTapped = false
        }
    }
}

struct DoubleTapPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTapPracticeView2()
    }
}
