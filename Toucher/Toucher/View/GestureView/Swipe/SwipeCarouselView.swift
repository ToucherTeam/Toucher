//
//  SwipeExampleView.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/04.
//

import SwiftUI

struct SwipeCarouselView: View {
    @AppStorage("createSwipe") var createSwipe = true
    @StateObject var swipeVM = SwipeViewModel()
    
    @State private var currentIndexArray: [Int] = []
    @State private var currentIndex = 0
    
    @GestureState private var dragOffset: CGFloat = 0
    @Namespace var animation

    private let deviceWidth = UIScreen.main.bounds.width
    private let spacing: CGFloat = 12
    private let trailingSpacing: CGFloat = 42
    private let swipeContent: [CarouselModel] = [
        .init(color: Color.customBG2),
        .init(color: Color.customPrimary)
    ]
    private let selectedGuideVideo: URLManager = .swipeCarouselView
    private let firestoreManager = FirestoreManager.shared
    
    var body: some View {
        ZStack {
            BackGroundColor(isFail: swipeVM.isFail, isSuccess: swipeVM.isSuccess)
            
            VStack {
                CustomToolbar(title: "살짝 쓸기", isSuccess: swipeVM.isSuccess, selectedGuideVideo: selectedGuideVideo)
                
                titleText
                    .foregroundColor(swipeVM.isFail && !swipeVM.isSuccess ? Color.customWhite : Color.black)
                    .multilineTextAlignment(.center)
                    .font(.customTitle)
                    .padding(.top, 42)
                    .padding(.horizontal)
                
                Spacer()
                
                HelpButton(selectedGuideVideo: selectedGuideVideo, style: swipeVM.isFail  ? .primary : .secondary)
                .opacity(swipeVM.isSuccess ? 0 : 1)
                .animation(.easeInOut, value: swipeVM.isSuccess)
            }
            .modifier(
                FirebaseStartViewModifier(
                    create: $createSwipe,
                    isSuccess: swipeVM.isSuccess,
                    viewName: .swipeCarouselView
                )
            )
            .onAppear {
                currentIndexArray = []
                swipeVM.reset()
            }
            .overlay(alignment: .leading) {
                carousel
                    .padding(.horizontal, 24)
            }
            .overlay(alignment: .center) {
                Arrows()
                    .rotationEffect((currentIndex == 0) ? .degrees(0) : .degrees(180))
                    .allowsHitTesting(false)
            }
            .overlay {
                indicator
            }
            .animation(.easeInOut, value: dragOffset == 0)
            .overlay {
                if swipeVM.isSuccess {
                    ConfettiView()
                }
            }
            .modifier(MoveToNextModifier(isNavigate: $swipeVM.isNavigate, isSuccess: $swipeVM.isSuccess))
            .navigationDestination(isPresented: $swipeVM.isNavigate) {
                SwipeListView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
        .analyticsScreen(name: "SwipeCarouselView")
    }
    
    private var titleText: some View {
        switch (swipeVM.isSuccess, currentIndex, swipeVM.isFail) {
        case (true, _, false):
            Text("잘하셨어요!\n")
            
        case (_, 0, true):
            Text("왼쪽으로\n 살짝쓸어보세요")
            
        case (_, 1, true):
            Text("오른쪽으로\n 살짝쓸어보세요")

        case (false, 0, false):
            Text("왼쪽으로 밀어볼까요?\n")

        default:
            Text("이번에 오른쪽으로\n밀어볼까요?")
        }
    }
    
    private var carousel: some View {
        let width = deviceWidth - (trailingSpacing - spacing)
        
        return HStack(spacing: spacing) {
            ForEach(swipeContent) { rectangle in
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: deviceWidth - trailingSpacing, height: 180)
                    .foregroundColor(rectangle.color)
            }
            .offset(x: (CGFloat(currentIndex) * -width) + dragOffset)
        }
        .gesture(
            TapGesture()
                .onEnded {
                    withAnimation {
                        swipeVM.isFail = true
                    }
                    FirestoreManager.shared.updateViewTapNumber(.swipe, .swipeCarouselView)
                    AnalyticsManager.shared.logEvent(name: "SwipeCarouselView_Fail")
                }
        )
        .gesture(
            dragOffset(width)
        )
    }
    
    private var indicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<swipeContent.count, id: \.self) { index in
                Circle()
                    .foregroundColor(.customBG2)
                    .frame(width: 8, height: 8)
                    .overlay {
                        if currentIndex == index {
                            Circle()
                                .foregroundColor(.customPrimary)
                                .frame(width: 8, height: 8)
                                .matchedGeometryEffect(id: "INDICATOR", in: animation)
                        }
                    }
                    .offset(y: 114)
            }
        }
    }
    
    /// Drag Offset 값을 조정하는 함수
    private func dragOffset(_ width: CGFloat) -> _EndedGesture<GestureStateGesture<DragGesture, CGFloat>> {
        return DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                let offsetX = value.translation.width
                let progress = -offsetX / width
                let roundIndex = progress.rounded()
                currentIndex = errorHandleArray(roundIndex)
                currentIndexArray.append(currentIndex)
                checkSuccessCondition(currentIndexArray)
            }
    }
    
    ///  현재 swipeContent 개수 만큼 Swipe가 가능하게 만들어 주는 함수 (에러 방지)
    private func errorHandleArray(_ roundIndex: CGFloat) -> Int {
        return max(min(currentIndex + Int(roundIndex), swipeContent.count - 1), 0)
    }
    /// SwipeExampleView 성공 조건 감지
    private func checkSuccessCondition(_ array: [Int]) {
        let lastIndex = array.count - 1
        if array[lastIndex] == 0 {
            swipeVM.isFail = true
            AnalyticsManager.shared.logEvent(name: "SwipeCarouselView_Fail")
        }
        if array.count >= 2 {
            if array[lastIndex] == 0 && array[lastIndex - 1] == 1 {
                swipeVM.isSuccess = true
                swipeVM.isFail = false
                AnalyticsManager.shared.logEvent(name: "SwipeCarouselView_ClearCount")
            } else if array[lastIndex] != array[lastIndex - 1] {
                swipeVM.isSuccess = false
                swipeVM.isFail = false
            } else {
                swipeVM.isSuccess = false
                swipeVM.isFail = true
                AnalyticsManager.shared.logEvent(name: "SwipeCarouselView_Fail")
            }
        }
    }
}

#Preview {
    SwipeCarouselView()
        .environment(\.locale, .init(identifier: "ko"))
}
