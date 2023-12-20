//
//  LongTapPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapPracticeView1: View {
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isFail = false
    
    @GestureState private var isPressed = false
    
    @State private var navigate = false
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "길게 누르기", isSuccess: isSuccess)
                
                Text(isSuccess ? "성공!\n\n" : isFail ? "조금 더 길게 꾹 \n눌러주세요!\n" : "카메라를 1초 동안\n눌러서 추가 기능을\n알아볼까요?")
                    .foregroundColor(isFail && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                
                cameraButton
                    .padding(.bottom)
                    .frame(maxHeight: .infinity)
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
            .frame(maxWidth: .infinity)
            .onChange(of: isSuccess) { _ in
                if isSuccess {
                    HapticManager.notification(type: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        navigate = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigate) {
                LongTapPracticeView2()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
        .onAppear {
            reset()
        }
    }
    
    private var cameraButton: some View {
        Image("Camera")
            .resizable()
            .frame(width: 130, height: 130)
            .foregroundStyle(.gray)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(isPressed ? .black.opacity(0.5) : .clear)
            }
            .scaleEffect(isPressed ? 1.1 : 1)
            .animation(.easeInOut(duration: 1), value: isPressed)
            .gesture(
                LongPressGesture(minimumDuration: 1.0)
                    .updating($isPressed) { value, gestureState, _ in
                        gestureState = value
                    }
                    .onEnded {_ in
                        withAnimation {
                            isSuccess = true
                            isTapped = true
                        }
                    }
                    .simultaneously(with: TapGesture()
                        .onEnded {
                            withAnimation {
                                isTapped = true
                                isFail = true
                            }
                        })
            )
            .background(alignment: .topLeading) {
                if isSuccess {
                    VStack {
                        Group {
                            HStack {
                                Text("복사")
                                Spacer()
                                Image(systemName: "doc.on.doc")
                            }
                            Divider()
                            HStack {
                                Text("공유")
                                Spacer()
                                Image(systemName: "square.and.arrow.up")
                            }
                            Divider()
                            HStack {
                                Text("즐겨찾기")
                                Spacer()
                                Image(systemName: "heart")
                            }
                            Divider()
                            HStack {
                                Text("삭제")
                                Spacer()
                                Image(systemName: "trash")
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .padding(10)
                    .frame(width: 200)
                    .background {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .foregroundStyle(Color(.systemGray6))
                    }
                    .offset(y: -180)
                    .transition(.scale)
                }
            }
    }
    
    private func reset() {
        isTapped = false
        isSuccess = false
        isFail = false
    }
}

struct LongTapPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        LongTapPracticeView1()
    }
}
