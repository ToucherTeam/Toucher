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
            Image("PanMap")
                .resizable()
                .scaledToFit()
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
                .overlay {
                    if !isSuccess {
                        VStack {
                            VstackArrow()
                                .rotationEffect(.degrees(180))
                            HStack {
                                HStackArrow()
                                    .padding(20)
                                HStackArrow()
                                    .rotationEffect(.degrees(180))
                                    .padding(20)
                            }
                            VstackArrow()
                        }
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
