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
    @State private var scale = 1.0
    
    @Namespace private var name
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack(spacing: 0) {
                CustomToolbar(title: "길게 누르기", isSuccess: isSuccess)
                
                ScrollView {
                    Text(isSuccess ? "성공!\n" : isFail ? "조금 더 길게 꾹 \n눌러주세요!" : "앨범의 사진을 꾹 눌러서\n미리 보아 볼까요?")
                        .foregroundColor(isFail && !isSuccess ? .white : .primary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .font(.customTitle)
                        .padding(.top, 40)
                    LazyVGrid(columns: columns) {
                        ForEach((1...15), id: \.self) { index in
                            if isSuccess {
                                Rectangle()
                                    .aspectRatio(1, contentMode: .fill)
                                    .overlay {
                                        Image("Album\(index)")
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .clipShape(Rectangle())
                            } else {
                                Rectangle()
                                    .aspectRatio(1, contentMode: .fill)
                                    .overlay {
                                        Image("Album\(index)")
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .clipShape(Rectangle())
                                    .matchedGeometryEffect(id: "Album\(index)", in: name)
                                    .zIndex(selectIndex == index ? 1 : 0)
                                    .scaleEffect(selectIndex == index && isPressed ? 1.2 : 1)
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
                    }
                    .ignoresSafeArea()
                    .overlay(alignment: .top) {
                        if isSuccess {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundStyle(.ultraThinMaterial)
                                .ignoresSafeArea()
                        }
                    }
                    .overlay(alignment: .top) {
                        if isSuccess {
                            if let selectedIndex {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .aspectRatio(1, contentMode: .fill)
                                    .overlay {
                                        Image("Album\(selectedIndex)")
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .matchedGeometryEffect(id: "Album\(selectedIndex)", in: name)
                                    .offset(y: -50)
                                    .zIndex(1)
                                    .frame(width: 360, height: 360)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
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
