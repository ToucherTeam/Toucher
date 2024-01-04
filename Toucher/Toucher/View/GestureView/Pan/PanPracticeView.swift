//
//  PanPracticeView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI
import CoreLocation

struct PanPracticeView: View {
    @StateObject private var navigationManager = NavigationManager.shared

    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isOneTapped = false
    @State private var imageOffset: CGSize = .zero
    @State private var gestureOffset: CGSize = .zero

    
    var body: some View {
        VStack(spacing: 0) {
            CustomToolbar(title: "화면 움직이기", isSuccess: isSuccess)
                .zIndex(1)
            
            ZStack {
                PanMap()
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                withAnimation {
                                    isSuccess = true
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
                
                Text(isSuccess ? "성공!\n" : "사방으로 움직여\n지도를 이동해보세요.\n")
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
                    .opacity(isSuccess ? 0 : 1)
                    .animation(.easeInOut, value: isSuccess)
                }
            }
            .overlay {
                if isSuccess {
                    ConfettiView()
                }
            }
            .onChange(of: isSuccess) { _ in
                if isSuccess {
                    HapticManager.notification(type: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        navigationManager.navigate = false
                        navigationManager.updateGesture()
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
}

struct PanPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PanPracticeView()
    }
}
