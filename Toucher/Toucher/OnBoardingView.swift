//
//  OnBoardingView.swift
//  Toucher
//
//  Created by bulmang on 12/20/23.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("first") private var isFirst = true
    
    @State private var isSuccess = false
    
    var body: some View {
        ZStack {
            Color.customWhite
            VStack(spacing: 0) {
                Text(isSuccess ? "잘하셨어요!" : "저를 한 번\n눌러보세요!")
                    .font(.customTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 96)
                    .padding(.vertical, 24)
                    .background(Color.customBG1)
                    .cornerRadius(12)
                    .shadow(color: Color.customShadow, radius: 5, x: 0, y: 4)
                Image("Polygon 1")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 165)
                    .shadow(color: Color.customShadow, radius: 5, x: 0, y: 4)
                
                TapButton(isSuccess: $isSuccess)
                    .padding(.top, 56)
            }
            .onChange(of: isSuccess) { value in
                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            self.isFirst = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    OnBoardingView()
}