//
//  DragPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct DragPracticeView1: View {
    @State private var isSuccess = false
    @State private var isFail = false
    @State private var value = 0.0
    @State private var navigate = false
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "끌어오기")
                
                Text(isSuccess ? "성공!\n" : isFail ? "꾹 누른 상태로 옮겨주세요.\n" : "원을 좌우로 움직여주세요.\n")
                    .foregroundColor(isFail && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                slider
                    .padding(.bottom, 120)
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
            DragPracticeView2()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            reset()
        }
    }
    
    private var slider: some View {
        ZStack(alignment: .leading) {
            Slider(value: $value)
                .onTapGesture {
                    if !isSuccess {
                        isFail = true
                    }
                }
            Group {
                Capsule()
                    .foregroundColor(Color(.systemGray5))
                    .frame(height: 30)
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width * value * 0.82 + 40, height: 30)
                    .foregroundColor(.accentColor)
                    .cornerRadius(20)
                Circle()
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .shadow(radius: 5)
                    .offset(x: UIScreen.main.bounds.width * value * 0.82)
            }
            .allowsHitTesting(false)
            .onChange(of: value) { newValue in
                if newValue >= 0.3 {
                    isSuccess = true
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal)
    }
    
    private func reset() {
        isSuccess = false
        isFail = false
        value = 0.0
    }
}

struct DragPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        DragPracticeView1()
    }
}
