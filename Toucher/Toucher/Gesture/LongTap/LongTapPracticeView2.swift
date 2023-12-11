//
//  LongTapPracticeView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapPracticeView2: View {
    @StateObject private var navigationManager = NavigationManager.shared

    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isFail = false
    
    @GestureState private var isPressed = false
    
    @State private var selectIndex: Int?
    @State private var selectedIndex: Int?
    @State var scale = 1.0
    
    @Namespace var name
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack(spacing: 0) {
                CustomToolbar(title: "길게 누르기")
                
                ScrollView {
                    Text(isSuccess ? "성공!\n" : isFail ? "조금 더 길게 꾹 \n눌러주세요!" : "앨범의 사진을 꾹 눌러서\n미리 보아 볼까요?")
                        .foregroundColor(isFail && !isSuccess ? .white : .primary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .font(.customTitle)
                        .padding(.top, 30)
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
                                                isSuccess = true
                                                isTapped = true
                                                scale = 1
                                                selectedIndex = index
                                            }
                                        }
                                        .simultaneously(with: TapGesture()
                                            .onEnded {
                                                withAnimation {
                                                    isTapped = true
                                                    isFail = true
                                                    scale = 1
                                                }
                                            })
                                )
                        }
                    }
                    .ignoresSafeArea()
                    .overlay {
                        if isSuccess {
                            Rectangle()
                                .foregroundStyle(.ultraThinMaterial)
                                .ignoresSafeArea()
                        }
                    }
                    .overlay(alignment: .top) {
                        if isSuccess {
                            if let selectedIndex {
                                Image("Album\(selectedIndex)")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(16)
                                    .offset(y: -50)
                                    .frame(width: 360)
                                    .matchedGeometryEffect(id: selectedIndex, in: name)
                                    .overlay {
                                        if isSuccess {
                                            ConfettiView()
                                        }
                                    }
                            }
                        }
                    }
                }
                .scrollDisabled(true)
                
                .overlay(alignment: .bottom) {
                    HelpButton(style: isFail ? .primary : .secondary) {
                        
                    }
                    .opacity(isSuccess ? 0 : 1)
                    .animation(.easeInOut, value: isSuccess)
                }
            }
        }
        .onChange(of: isSuccess) { _ in
            if isSuccess {
                HapticManager.notification(type: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    navigationManager.navigate = false
                    navigationManager.updateGesture()
                }
            }
        }
        .onAppear {
            isTapped = false
            isSuccess = false
            isFail = false
        }
    }
}

struct LongTapPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        LongTapPracticeView2()
    }
}
