//
//  DoubleTapPracticeView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapPracticeView2: View {
    
    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var isOneTapped = false
    
    let UIWidth = UIScreen.main.bounds.width
    let UIHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            ScrollView([.horizontal, .vertical]) {
                Image("ex_image")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        maxWidth: isSuceess ? UIWidth * 2 : UIWidth,
                        maxHeight: isSuceess ? UIHeight * 2 : UIHeight)
                    .ignoresSafeArea()
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
            }
            .scrollIndicators(.hidden)
            
            Text(isSuceess ? "잘하셨어요!\n" : isOneTapped ? "조금만 더 빠르게 두 번\n눌러주세요!" : "빠르게 두 번 눌러\n사진을 확대해볼까요?")
                .foregroundColor(isOneTapped && !isSuceess ? .accentColor : .primary)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
                .frame(maxHeight: .infinity, alignment: .top)
            if isSuceess {
                NavigationLink {
                    
                } label: {
                    Text("완료")
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
        .onAppear {
            isTapped = false
            isSuceess = false
            isOneTapped = false
        }
    }
}

struct DoubleTapPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
            DoubleTapPracticeView2()
    }
}
