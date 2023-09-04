//
//  DragExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct DragExampleView: View {
    @State private var isSuceess = false
    @State private var isPressed = false
    @State private var isTapPressed = false
    @State private var isOneTapped = false
    @State private var isArrived = false
    
    @State private var offset: CGSize = .zero
    @State private var scale = 1.0
    
    @Namespace var circle
    
    var body: some View {
        ZStack {
            if isOneTapped && !isSuceess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                Text(isSuceess ? "잘하셨어요!" : isOneTapped ? "꾹 누른 상태로 옮겨주세요." : isPressed ? "아래 원으로 옮겨보세요" : "캐릭터를 꾹 눌러 볼까요?")
                    .foregroundColor(isOneTapped && !isSuceess ? .white : .primary)
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
                        if isSuceess {
                            Image("ch_button")
                                .resizable()
                                .scaledToFit()
                                .matchedGeometryEffect(id: "circle", in: circle)
                                .frame(width: 120)
                                .foregroundColor(.green)
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    if !isSuceess {
                        Image("ch_button")
                            .resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: "circle", in: circle)
                            .frame(width: 100 * scale)
                            .foregroundStyle(.gray.opacity(0.5))
                            .offset(offset)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        offset = CGSize(width: value.startLocation.x + value.translation.width - 100/2,
                                                        height: value.startLocation.y + value.translation.height - 100/2)
                                        withAnimation(.easeInOut) {
                                            scale = 1.2
                                            isPressed = true
                                        }
                                    }
                                    .onEnded { value in
                                        
                                        if 200...250 ~= value.translation.height, -20...20 ~= value.translation.width {
                                            isArrived = true
                                        }
                                        
                                        if isArrived {
                                            withAnimation() {
                                                isSuceess = true
                                            }
                                        }
                                        
                                        if !isArrived {
                                            withAnimation(.easeInOut) {
                                                offset = .zero
                                                scale = 1
                                                isPressed = false
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
                
                Group {
                    Text("아이콘을 움직일 때,\n음량을 바꿀 때 ")
                        .bold()
                    + Text("사용해요.")
                }
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .foregroundColor(isPressed ? .clear : .gray)
                .font(.title)
                .padding(.bottom, 80)
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
                Text("끌어오기")
            }
        }
        .onAppear {
            isPressed = false
            isSuceess = false
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
