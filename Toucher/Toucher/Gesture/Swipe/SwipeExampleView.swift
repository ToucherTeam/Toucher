//
//  SwipeExampleView.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/04.
//

import SwiftUI

struct SwipeExampleView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @StateObject var swipeVM = SwipeViewModel()
    
    @GestureState private var dragOffset: CGFloat = 0
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            VStack {
                titleText()
                
                Spacer()
                
                carousel()
                    .overlay(
                        Arrows()
                            .rotationEffect( (swipeVM.currentIndex == -1) ? .degrees(0) : .degrees(180))
                    )
                    .overlay(indicator())
                Spacer()
                
                footerContent()
            }
            .animation(.easeInOut, value: dragOffset == 0)
            
            nextButton()
        }
        .onAppear {
            print(mainVM.navigationPath)
            }
    }
    
    @ViewBuilder
    func footerContent() -> some View {
        switch (swipeVM.tap, checkSuccessCondition(swipeVM.currentIndexArray)) {
        case (false, _):
            descriptionText()
                .frame(height: swipeVM.headerAreaHeight.size.height)
                .padding(.bottom, 89)
        default:
            descriptionText()
                .frame(height: swipeVM.headerAreaHeight.size.height)
                .opacity(0)
                .padding(.bottom, 89)
        }
    }
    
    @ViewBuilder
    func titleText() -> some View {
        Text(checkSuccessCondition(swipeVM.currentIndexArray) ? "잘하셨어요!\n" : (swipeVM.currentIndex == -1) ? "왼쪽으로 밀어볼까요?\n" : "이번에 오른쪽으로\n밀어볼까요?")
            .multilineTextAlignment(.center)
            .font(.customTitle())
            .padding(.top, 42)
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
        )
        .gesture(
            dragOffset(width)
        )
    }
    
    @ViewBuilder
    func descriptionText() -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Text("현재 ")
                    .font(.customDescription())
                Text("보이지 않는 화면을")
                    .font(.customDescriptionEmphasis())
            }
            HStack(spacing: 0) {
                Text("찾을 때")
                    .font(.customDescriptionEmphasis())
                Text("주로 사용해요.")
                    .font(.customDescription())
            }
        }
        .foregroundColor(Color("GR1"))
        .modifier(GetHeightModifier())
        .onPreferenceChange(ContentRectSize.self) { rects in
            swipeVM.headerAreaHeight = rects
        }
    }
    
    @ViewBuilder
    func indicator() -> some View {
        HStack(spacing: 8) {
            ForEach(0..<swipeVM.swipeContent.count) { index in
                Circle()
                    .foregroundColor(Color("BG2"))
                    .frame(width: 8, height: 8)
                    .overlay {
                        if swipeVM.currentIndex == index - 1 {
                            Circle()
                                .foregroundColor(Color("Primary"))
                                .frame(width: 8, height: 8)
                                .matchedGeometryEffect(id: "INDICATOR", in: animation)
                        }
                    }
                    .offset(y: 114)
            }
        }
    }
    
    @ViewBuilder
    func nextButton() -> some View {
        if checkSuccessCondition(swipeVM.currentIndexArray) {
            NavigationLink {
                SwiftPracticeView1()
            } label: {
                Text("다음")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: UIScreen.main.bounds.width - 32)
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom)
            .overlay(alignment: .bottom) {
                VstackArrow()
                    .offset(y: -100)
            }
        }
    }
    
    fileprivate func checkSuccessCondition<T>(_ sequence: T) -> Bool where T: Sequence, T.Element == Int {
        var iterator = sequence.makeIterator()
        var previousElement: Int?
        
        while let element = iterator.next() {
            if element == 0, let nextElement = iterator.next(), nextElement == -1 {
                return true
            }
            previousElement = element
        }
        
        return false
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
                swipeVM.currentIndex = max(min(swipeVM.currentIndex + Int(roundIndex), swipeVM.swipeContent.count - 2), -1)
                swipeVM.currentIndexArray.append(swipeVM.currentIndex)
            }
    }
}

struct SwipeExampleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE")
            
            MainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
                .previewDisplayName("iPhone 14")
        }
    }
}

struct Arrows: View {
    @State var scale: CGFloat = 1.0
    @State var fade: Double = 0.2
    @State var isAnimating: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 36)
            .fill(.white.opacity(0.5))
            .frame(width: 180, height: 72)
            .overlay(alignment: .trailing) {
                HStack(spacing: 0) {
                    ForEach(0..<3) { index in
                        Image(systemName: "chevron.left")
                            .font(.system(size: 28))
                            .fontWeight(.black)
                            .foregroundColor(Color("Primary"))
                            .opacity(self.fade)
                            .scaleEffect(self.scale)
                            .animation(Animation.easeOut(duration: 0.9)
                                .repeatForever(autoreverses: true)
                                .delay(0.3 * Double(3 - index)), value: isAnimating)
                    }
                    Circle()
                        .foregroundColor(Color("Secondary"))
                        .frame(width: 56, height: 56)
                        .padding(.leading, 19)
                        .padding(.trailing, 8)
                }
            }
            .onAppear {
                self.isAnimating = true
                self.scale = 1.1
                self.fade = 1.0
            }
    }
}

struct VstackArrow: View {
    @State var scale: CGFloat = 1.0
    @State var fade: Double = 0.2
    @State var isAnimating: Bool = false
    
    var body: some View {
        VStack {
            ForEach(0..<3) { index in
                Image(systemName: "chevron.down")
                    .font(.system(size: 28))
                    .fontWeight(.black)
                    .foregroundColor(Color("Primary"))
                    .opacity(self.fade)
                    .scaleEffect(self.scale)
                    .animation(Animation.easeOut(duration: 0.9)
                        .repeatForever(autoreverses: true)
                        .delay(0.3 * Double(3 + index)), value: isAnimating)
            }
        }
        .onAppear {
            self.isAnimating = true
            self.scale = 1.1
            self.fade = 1.0
        }
        
    }
}
