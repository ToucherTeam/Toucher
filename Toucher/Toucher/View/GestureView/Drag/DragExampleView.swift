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
    @State private var isFail = false
    @State private var isArrived = false
    @State private var navigate = false
    
    @State private var offset: CGSize = .zero
    @State private var scale = 1.0
    
    @Namespace var circle
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "끌어오기", isSuccess: isSuccess)

                Text(isSuccess ? "성공!" : isFail ? "꾹 누른 상태로 옮겨주세요." : isPressed ? "아래 원으로 옮겨보세요" : "캐릭터를 꾹 눌러 볼까요?")
                    .foregroundColor(isFail && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                ZStack {
                    ZStack {
                        Image("drag_asset")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .zIndex(-1)
                        if isSuccess {
                            Image("ToucherCharacter")
                                .resizable()
                                .scaledToFit()
                                .matchedGeometryEffect(id: "circle", in: circle)
                                .frame(width: 100)
                                .foregroundColor(.green)
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    if !isSuccess {
                        Image("ToucherCharacter")
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
                                                isFail = true
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
                .overlay {
                    if isSuccess {
                        ConfettiView()
                    }
                }
                .padding(.vertical, 50)
                .background {
                    if isPressed && !isSuccess {
                        VStackArrow()
                    }
                }
                
                HelpButton(style: isFail ? .primary : .secondary, currentViewName: "DragExampleView") {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
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
            DragPracticeView1()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            reset()
        }
    }
    
    private func reset() {
        isSuccess = false
        isPressed = false
        isTapPressed = false
        isFail = false
        isArrived = false
        
        offset = .zero
        scale = 1.0
    }
}

struct DragExampleView_Previews: PreviewProvider {
    static var previews: some View {
        DragExampleView()
    }
}
