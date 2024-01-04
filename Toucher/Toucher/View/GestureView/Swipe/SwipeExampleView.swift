//
//  SwipeExampleView.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/04.
//

import SwiftUI

struct SwipeExampleView: View {
    @StateObject var swipeVM = SwipeViewModel()
    
    @GestureState private var dragOffset: CGFloat = 0
    
    @Namespace var animation
    
    @State private var isFail = false
    @State private var navigate = false
    @State private var isSuccess = false
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            
            VStack {
                CustomToolbar(title: "살짝 쓸기", isSuccess: isSuccess)
                
                titleText()
                
                Spacer()
                
                HelpButton(style: isFail  ? .primary : .secondary, currentViewName: "SwipeExampleView") {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
            }
            .onAppear {
                swipeVM.currentIndexArray = []
                isFail = false
                isSuccess = false
            }
            .overlay(alignment: .leading) {
                carousel()
                    .padding(.horizontal, 24)
            }
            .overlay(alignment: .center) {
                Arrows()
                    .rotationEffect( (swipeVM.currentIndex == 0) ? .degrees(0) : .degrees(180))
                    .allowsHitTesting(false)
            }
            .overlay(alignment: .center) {indicator()}
            .animation(.easeInOut, value: dragOffset == 0)
            .overlay {
                if isSuccess {
                    ConfettiView()
                }
            }
            .onChange(of: isSuccess) { _ in
                if isSuccess {
                    HapticManager.notification(type: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        navigate = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigate) {
                SwipePracticeView1()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
    
    @ViewBuilder
    func titleText() -> some View {
        switch (isSuccess, swipeVM.currentIndex, isFail) {
        case (true, _, false):
            Text("잘하셨어요!\n")
                .multilineTextAlignment(.center)
                .font(.customTitle)
                .padding(.top, 42)
            
        case (_, 0, true):
            Text("왼쪽으로\n 살짝쓸어보세요")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.customTitle)
                .padding(.top, 42)
            
        case (_, 1, true):
            Text("오른쪽으로\n 살짝쓸어보세요")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.customTitle)
                .padding(.top, 42)
            
        case (false, 0, false):
            Text("왼쪽으로 밀어볼까요?\n")
                .multilineTextAlignment(.center)
                .font(.customTitle)
                .padding(.top, 42)
            
        default:
            Text("이번에 오른쪽으로\n밀어볼까요?")
                .multilineTextAlignment(.center)
                .font(.customTitle)
                .padding(.top, 42)
        }
    }
    
    @ViewBuilder
    func carousel() -> some View {
        let width = swipeVM.deviceWidth - (swipeVM.trailingSpacing - swipeVM.spacing)
        
        HStack(spacing: swipeVM.spacing) {
            ForEach(swipeVM.swipeContent) { rectangle in
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: swipeVM.deviceWidth - swipeVM.trailingSpacing, height: 180)
                    .foregroundColor(rectangle.color)
            }
            .offset(x: (CGFloat(swipeVM.currentIndex) * -width) + dragOffset)
        }
        .gesture(
            LongPressGesture()
                .onChanged { _ in
                    swipeVM.tap = true
                }
                .onEnded { _ in
                    swipeVM.tap = true
                }
                .exclusively(
                    before: TapGesture()
                        .onEnded {
                            withAnimation {
                                isFail = true
                            }
                        })
        )
        .gesture(
            dragOffset(width)
        )
    }
    
    @ViewBuilder
    func indicator() -> some View {
        HStack(spacing: 8) {
            ForEach(0..<swipeVM.swipeContent.count, id: \.self) { index in
                Circle()
                    .foregroundColor(.customBG2)
                    .frame(width: 8, height: 8)
                    .overlay {
                        if swipeVM.currentIndex == index {
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
    
    fileprivate func errorHandleArray(_ roundIndex: CGFloat) -> Int {
        return max(min(swipeVM.currentIndex + Int(roundIndex), swipeVM.swipeContent.count - 1), 0)
    }
    
    fileprivate func dragOffset(_ width: CGFloat) -> _EndedGesture<GestureStateGesture<DragGesture, CGFloat>> {
        return DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                let offsetX = value.translation.width
                let progress = -offsetX / width
                let roundIndex = progress.rounded()
                swipeVM.currentIndex = errorHandleArray(roundIndex)
                swipeVM.currentIndexArray.append(swipeVM.currentIndex)
                checkSuccessCondition(swipeVM.currentIndexArray)
            }
    }
    
    fileprivate func checkSuccessCondition(_ array: [Int]) {
        let lastIndex = array.count - 1
        if array[lastIndex] == 0 {
            self.isFail = true
        }
        if array.count >= 2 {
            if array[lastIndex] == 0 && array[lastIndex - 1] == 1 {
                self.isSuccess = true
                self.isFail = false
            } else if array[lastIndex] != array[lastIndex - 1] {
                self.isSuccess = false
                self.isFail = false
            } else {
                self.isSuccess = false
                self.isFail = true
            }
        }
    }
}

struct SwipeExampleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SwipeExampleView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE")
            
            SwipeExampleView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
                .previewDisplayName("iPhone 14")
        }
    }
}
