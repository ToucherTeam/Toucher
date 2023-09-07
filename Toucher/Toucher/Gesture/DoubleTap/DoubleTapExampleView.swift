//
//  DoubleTapExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapExampleView: View {

    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var isOneTapped = false
    
    var body: some View {
        ZStack {
            if isOneTapped && !isSuceess {
                Color("Secondary_alert").ignoresSafeArea()
            }
            VStack {
                Text(isSuceess ? "잘하셨어요!\n" : isOneTapped ? "조금만 더 빠르게\n두 번 눌러주세요!" : "빠르게 두 번\n눌러볼까요?")
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
                    .gesture(
                        TapGesture(count: 2)
                            .onEnded {
                                withAnimation {
                                    isSuceess = true
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
                    .frame(maxHeight: .infinity)
                
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
                    .foregroundColor(isTapped ? .clear : .gray)
                    .font(.title)
                    .padding(.bottom, 80)
            }
            if isSuceess {
                ToucherNavigationLink {
                    DoubleTapPracticeView1()
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

struct DoubleTapExampleView_Previews: PreviewProvider {
    static var previews: some View {
            DoubleTapExampleView()
    }
}
