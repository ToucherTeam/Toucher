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
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
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
                    .overlay(alignment: .topLeading) {
                        if isSuceess {
                            VStack {
                                HStack {
                                    Text("Copy")
                                    Spacer()
                                    Image(systemName: "doc.on.doc")
                                }
                                Divider()
                                HStack {
                                    Text("Share")
                                    Spacer()
                                    Image(systemName: "square.and.arrow.up")
                                }
                                Divider()
                                HStack {
                                    Text("Favorite")
                                    Spacer()
                                    Image(systemName: "heart")
                                }
                                Divider()
                                HStack {
                                    Text("Delete")
                                    Spacer()
                                    Image(systemName: "doc.on.doc")
                                }
                                .foregroundColor(.red)
                            }
                            .padding(10)
                            .frame(width: 200)
                            .background {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .foregroundStyle(.thinMaterial)
                            }
                            .offset(y: -180)
                            .transition(.scale)
                        }
                    }
                Spacer()
                Spacer()
            }
            if isSuceess {
                NavigationLink {
                    LongTapPracticeView2()
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

struct LongTapPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        LongTapPracticeView1()
    }
}
