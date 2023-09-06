//
//  DoubleTapPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapPracticeView1: View {
    
    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var isOneTapped = false
    
    var body: some View {
        ZStack {
            if isOneTapped && !isSuceess {
                Color("Secondary_alert").ignoresSafeArea()
            }
            VStack {
                Text(isSuceess ? "잘하셨어요!\n" : isOneTapped ? "조금만 더 빠르게\n두 번 눌러주세요!" : "검색창을 두 번\n눌러볼까요?")
                    .foregroundColor(isOneTapped && !isSuceess ? .white : .primary)
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
                .overlay(alignment: .leading) {
                    if isSuceess {
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Action 1")
                                Divider()
                                Text("Action 2")
                                Divider()
                                Text("Action 3")
                            }
                            .padding(5)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                            .frame(height: 50)
                            .background {
                                VStack(spacing: 0) {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                }
                                .foregroundStyle(Color(.systemGray6))
                            }
                            .padding(.leading, 40)
                            .padding(.bottom, 100)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
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
            if isSuceess {
                NavigationLink {
                    DoubleTapPracticeView2()
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
        .onAppear {
            isTapped = false
            isSuceess = false
            isOneTapped = false
        }
    }
}

struct DoubleTapPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTapPracticeView1()
    }
}
