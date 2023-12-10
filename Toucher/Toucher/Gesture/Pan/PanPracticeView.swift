//
//  PanPracticeView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PanPracticeView: View {
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isOneTapped = false
    
    @State private var imageOffset: CGSize = .zero
    @State private var gestureOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Image("Map")
                .resizable()
                .scaledToFill()
                .frame(maxHeight: .infinity)
                .offset(x: imageOffset.width + gestureOffset.width, y: imageOffset.height + gestureOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            gestureOffset = CGSize(width: value.translation.width, height: value.translation.height)
                            withAnimation(.easeInOut) {
                                isSuccess = true
                            }
                        }
                        .onEnded { value in
                            imageOffset.width += value.translation.width
                            imageOffset.height += value.translation.height
                            gestureOffset = .zero
                        }
                )
            if !isSuccess {
                VStack {
                    HStackArrow()
                        .rotationEffect(.degrees(90))
                    HStack(spacing: 60) {
                        VstackArrow()
                            .rotationEffect(.degrees(90))
                            .padding(20)
                        VstackArrow()
                            .rotationEffect(.degrees(-90))
                            .padding(20)
                    }
                    HStackArrow()
                        .rotationEffect(.degrees(-90))
                }
            }
            GeometryReader { geometry in
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(alignment: .top) {
                        Text("")
                            .frame(height: geometry.safeAreaInsets.top)
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.white
                            }
                            .edgesIgnoringSafeArea(.top)
                    }
            }
            
            Text(isSuccess ? "잘하셨어요!\n" : "사방으로 움직여\n지도를 이동해보세요.")
                .foregroundColor(isOneTapped && !isSuccess ? .white : .primary)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
                .frame(maxHeight: .infinity, alignment: .top)
            
            if isSuccess {
                VStack(spacing: 0) {
                    CustomToolbar(title: "화면 움직이기")
                    ToucherNavigationLink(label: "완료") {
                        FinalView(gestureTitle: "화면 움직이기")
                    }
                }
            }
        }
        
        .onAppear {
            isTapped = false
            isSuccess = false
            isOneTapped = false
        }
    }
}

struct PanPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PanPracticeView()
    }
}
