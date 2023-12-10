//
//  MainViewHeader.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

struct MainViewHeader: View {
    var gesture: GestureType
    
    var practiceNum: String {
        switch gesture {
        case .doubleTap:
            "학습 1"
        case .longPress:
            "학습 2"
        case .swipe:
            "학습 3"
        case .drag:
            "학습 4"
        case .pan:
            "학습 5"
        case .pinch:
            "학습 6"
        case .rotate:
            "학습 7"
        }
    }
    var title: String {
        switch gesture {
        case .doubleTap:
            "두번 누르기"
        case .longPress:
            "길게 누르기"
        case .swipe:
            "살짝 쓸기"
        case .drag:
            "끌어오기"
        case .pan:
            "화면 움직이기"
        case .pinch:
            "확대 축소하기"
        case .rotate:
            "회전하기"
        }
    }
    
    var body: some View {
        HStack(spacing: 24) {
            Image("\(gesture.rawValue)Icon")
                .resizable()
                .frame(width: 60, height: 60)
            HStack(spacing: 8) {
                Text(practiceNum)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                Text(title)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
            }
            .foregroundColor(.customPrimary)
        }
        .padding(.trailing)
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .foregroundStyle(Color.customBG0)
                .shadow(color: .customShadow, radius: 10, y: 4)
        }
        .padding()
    }
}

#Preview {
    ZStack {
        Color.customBG1.ignoresSafeArea()
        
        MainViewHeader(gesture: .longPress)
    }
}
