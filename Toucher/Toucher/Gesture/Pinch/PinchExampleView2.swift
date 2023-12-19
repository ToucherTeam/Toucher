//
//  PinchExampleView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PinchExampleView2: View {
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isFail = false
    @State private var scale: CGFloat = 1
    
    @State private var navigate = false
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            
            VStack {
                CustomToolbar(title: "확대 축소하기")

                Text(isSuccess ? "성공!\n" : isFail ? "두 손가락을 동시에\n움직여보세요!" : "이번엔 크기를 작게\n만들어 볼까요?")
                    .foregroundColor(isFail && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                
                Image("ToucherCharacter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160)
                    .scaleEffect(scale)
                    .frame(width: 360, height: 320)
                    .contentShape(Rectangle())
                    .gesture(gesture)
                    .frame(maxHeight: .infinity)
                    .overlay {
                        if !isTapped || isFail && !isSuccess {
                            HStack(spacing: 100) {
                                Arrows(arrowColor: .customBG1)
                                    .rotationEffect(.degrees(180))
                                Arrows(arrowColor: .customBG1)
                            }
                            .rotationEffect(.degrees(-45))
                            .allowsHitTesting(false)
                        }
                    }
                    .overlay {
                        if isSuccess {
                            ConfettiView()
                        }
                    }
                
                HelpButton(style: isFail ? .primary : .secondary) {
                    
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
            PinchPracticeView1()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            reset()
        }
    }
    
    private var gesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                withAnimation {
                    isTapped = true
                    self.scale = min(max(value.magnitude, 0.25), 1.5)
                }
            }
            .onEnded { _ in
                withAnimation {
                    if scale < 0.8 {
                        isSuccess = true
                        self.scale = 0.6
                    }
                }
            }
            .simultaneously(
                with: TapGesture()
                    .onEnded { _ in
                        withAnimation {
                            isFail = true
                        }
                    }
            )
            .simultaneously(
                with: DragGesture()
                    .onEnded { _ in
                        withAnimation {
                            isFail = true
                        }
                    }
            )
    }
    
    private func reset() {
        isTapped = false
        isSuccess = false
        isFail = false
        scale = 1
    }
}

struct PinchExampleView2_Previews: PreviewProvider {
    static var previews: some View {
        PinchExampleView2()
    }
}
