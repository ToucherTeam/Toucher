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
    
    @GestureState private var isPressed = false
    
    @State private var selectIndex: Int?
    @State private var selectedIndex: Int?
    @State var scale = 1.0
    
    @Namespace var name
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ZStack {
            if isOneTapped && !isSuceess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            ScrollView {
                Text(isSuceess ? "잘하셨어요!\n" : isOneTapped ? "조금 더 길게 꾹 \n눌러주세요!" : "앨범의 사진을 꾹 눌러서\n미리 보아 볼까요?")
                    .foregroundColor(isOneTapped && !isSuceess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                //                ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach((1...15), id: \.self) { index in
                        Image("Album\(index)")
                            .resizable()
                            .frame(height: 130)
                            .scaleEffect(selectIndex == index && isPressed ? 1.2 : 1)
                            .matchedGeometryEffect(id: index, in: name)
                            .zIndex(selectIndex == index ? 1 : 0)
                            .animation(.easeIn, value: isPressed)
                            .foregroundStyle(.gray)
                            .gesture(
                                LongPressGesture(minimumDuration: 1.0)
                                    .updating($isPressed) { value, gestureState, _ in
                                        gestureState = value
                                    }
                                    .onChanged { _ in
                                        selectIndex = index
                                    }
                                    .onEnded {_ in
                                        withAnimation {
                                            isSuceess = true
                                            isTapped = true
                                            scale = 1
                                            selectedIndex = index
                                        }
                                    }
                                    .simultaneously(with: TapGesture()
                                        .onEnded {
                                            withAnimation {
                                                isTapped = true
                                                isOneTapped = true
                                                scale = 1
                                            }
                                        })
                            )
                    }
                }
                //                }
                .ignoresSafeArea()
                .overlay {
                    if isSuceess {
                        Rectangle()
                            .foregroundStyle(.ultraThinMaterial)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isSuceess = false
                                isOneTapped = false
                                selectedIndex = nil
                            }
                    }
                }
                .overlay(alignment: .top) {
                    if isSuceess {
                        if let selectedIndex {
                            Image("Album\(selectedIndex)")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                                .offset(y: -50)
                                .frame(width: 360)
                                .matchedGeometryEffect(id: selectedIndex, in: name)
                        }
                    }
                }
            }
            .scrollDisabled(true)
            if isSuceess {
                ToucherNavigationLink {
                    FinalView(gestureTitle: "길게 누르기")
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
                }
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
