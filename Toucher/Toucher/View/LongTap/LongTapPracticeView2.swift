//
//  LongTapPracticeView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapPracticeView2: View {
    @State private var isTapped = false
    @State private var isSuceess = false
    @State private var isOneTapped = false
    
    @State private var selectedIndex: Int?
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
        
    var body: some View {
        ZStack {
            if isOneTapped && !isSuceess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                Text(isSuceess ? "잘하셨어요!\n" : isOneTapped ? "조금 더 길게 꾹 \n눌러주세요!" : "앨범의 사진을 꾹 눌러서\n미리 보아 볼까요?")
                    .foregroundColor(isOneTapped && !isSuceess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach((1...15), id: \.self) { index in
                            Image("Album\(index)")
                                .resizable()
                                .frame(height: 130)
                                .foregroundStyle(.gray)
                                .gesture(
                                    LongPressGesture(minimumDuration: 1.0)
                                        .onEnded {_ in
                                            withAnimation {
                                                isSuceess = true
                                                isTapped = true
                                                selectedIndex = index
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
                        }
                    }
                }
                .ignoresSafeArea()
                .overlay {
                    if isSuceess {
                        Rectangle()
                            .foregroundStyle(.ultraThinMaterial)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isSuceess = false
                                isOneTapped = false
                            }
                    }
                }
                .overlay(alignment: .top) {
                    if isSuceess {
                        if let selectedIndex {
                            Image("Album\(selectedIndex)")
                                .resizable()
                                .frame(width: 360, height: 360)
                                .offset(y: -50)
                                .foregroundStyle(.gray)
                        }
                    }
                }
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

struct LongTapPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        LongTapPracticeView2()
    }
}
