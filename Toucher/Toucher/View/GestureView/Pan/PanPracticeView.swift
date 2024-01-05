//
//  PanPracticeView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI
import CoreLocation

struct PanPracticeView: View {
    @StateObject private var panVM = PanViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            CustomToolbar(title: "화면 움직이기", isSuccess: panVM.isSuccess)
                .zIndex(1)
            
            ZStack {
                PanMap()
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                withAnimation {
                                    panVM.isSuccess = true
                                }
                            }
                    )
                
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
                
                Text(panVM.isSuccess ? "성공!\n" : "사방으로 움직여\n지도를 이동해보세요.\n")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
                    .background {
                        Rectangle()
                            .foregroundColor(.customWhite.opacity(0.7))
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                VStack {
                    Spacer()
                    HelpButton(style: .secondary, currentViewName: "PanPracticeView")
                    .opacity(panVM.isSuccess ? 0 : 1)
                    .animation(.easeInOut, value: panVM.isSuccess)
                }
            }
            .overlay {
                if panVM.isSuccess {
                    ConfettiView()
                }
            }
            .modifier(EndNavigateModifier(isNavigate: $panVM.isNavigate, isSuccess: $panVM.isSuccess))
            .onAppear {
                panVM.reset()
            }
        }
    }
}

struct PanPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PanPracticeView()
    }
}
