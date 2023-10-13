//
//  DragExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct DragExampleView: View {
    @State private var isSuccess = false
    @State private var isPressed = false
    @State private var isTapPressed = false
    @State private var isOneTapped = false
    @State private var isArrived = false
    
    @State private var offset: CGSize = .zero
    @State private var scale = 1.0
    
    @Namespace var circle
    
    var body: some View {
        ZStack {
            if isOneTapped && !isSuccess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                Text(isSuccess ? "잘하셨어요!" : isOneTapped ? "꾹 누른 상태로 옮겨주세요." : isPressed ? "아래 원으로 옮겨보세요" : "캐릭터를 꾹 눌러 볼까요?")
                    .foregroundColor(isOneTapped && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                ZStack {
                    ZStack {
                        Image("drag_asset")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .zIndex(-1)
                        if isSuccess {
                            Image("ch_button")
                                .resizable()
                                .scaledToFit()
                                .matchedGeometryEffect(id: "circle", in: circle)
                                .frame(width: 120)
                                .foregroundColor(.green)
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    if !isSuccess {
                        Image("ch_button")
                            .resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: "circle", in: circle)
                            .frame(width: 100 * scale)
                            .foregroundStyle(.gray.opacity(0.5))
                            .offset(offset)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .zIndex(1)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let start = value.startLocation
                                        let trans = value.translation
                                        
                                        offset = CGSize(width: start.x + trans.width - 100/2,
                                                        height: start.y + trans.height - 100/2)
                                        withAnimation(.easeInOut) {
                                            scale = 1.2
                                            isPressed = true
                                        }
                                    }
                                    .onEnded { value in
                                        if  UIScreen.main.bounds.height * 0.2...UIScreen.main.bounds.height * 0.5 ~= value.translation.height &&
                                             -30...30 ~= value.translation.width {
                                            isArrived = true
                                        }
                                        
                                        if isArrived {
                                            withAnimation {
                                                isSuccess = true
                                            }
                                        }
                                        
                                        if !isArrived {
                                            withAnimation(.easeInOut) {
                                                offset = .zero
                                                scale = 1.2
                                                isPressed = false
                                                isOneTapped = true
                                            }
                                        }
                                    }
                                    .simultaneously(with: LongPressGesture(minimumDuration: 0)
                                        .onEnded { _ in
                                            withAnimation {
                                                scale = 1.2
                                                isPressed = true
                                            }
                                        }
                                    )
                            )
                    }
                }
                .frame(maxHeight: .infinity)
                .padding(.vertical, 50)
                .background {
                    if isPressed && !isSuccess {
                        VStackArrow()
                    }
                }
                
                Group {
                    Text("아이콘을 움직일 때,\n음량을 바꿀 때 ")
                        .bold()
                    + Text("사용해요.")
                }
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .foregroundColor(isPressed || isOneTapped ? .clear : .gray)
                .font(.title)
                .padding(.bottom, 80)
            }
            if isSuccess {
                ToucherNavigationLink {
                    DragPracticeView1()
                }
            }
            
        }
        .onAppear {
            isPressed = false
            isSuccess = false
            isOneTapped = false
            offset = .zero
        }
    }
}

struct DragExampleView_Previews: PreviewProvider {
    static var previews: some View {
        DragExampleView()
    }
}
