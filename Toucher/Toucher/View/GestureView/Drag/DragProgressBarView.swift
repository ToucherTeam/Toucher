//
//  DragProgressBarView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct DragProgressBarView: View {
    @StateObject private var dragVM = DragViewModel()
    
    @State private var value = 0.0
    
    private let selectedGuideVideo: URLManager = .dragProgressBarView
    
    var body: some View {
        ZStack {
            if dragVM.isFail && !dragVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "끌어오기", isSuccess: dragVM.isSuccess)
                
                ZStack {
                    VStack {
                        Text(dragVM.isSuccess ? "성공!\n" : dragVM.isFail ? "꾹 누른 상태로 옮겨주세요.\n" : "원을 좌우로 움직여주세요.\n")
                            .foregroundColor(dragVM.isFail && !dragVM.isSuccess ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .font(.customTitle)
                            .padding(.top, 40)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        HelpButton(selectedGuideVideo: selectedGuideVideo, style: dragVM.isFail ? .primary : .secondary)
                            .opacity(dragVM.isSuccess ? 0 : 1)
                            .animation(.easeInOut, value: dragVM.isSuccess)
                    }
                    
                    slider
                        .overlay {
                            if dragVM.isSuccess {
                                ConfettiView()
                            }
                        }
                }
            }
        }
        .modifier(MoveToNextModifier(isNavigate: $dragVM.isNavigate, isSuccess: $dragVM.isSuccess))
        .navigationDestination(isPresented: $dragVM.isNavigate) {
            DragAppIconView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            dragVM.reset()
            value = 0.0
        }
    }
    
    private var slider: some View {
        ZStack(alignment: .leading) {
            Slider(value: $value)
                .onTapGesture {
                    if !dragVM.isSuccess {
                        dragVM.isFail = true
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
                    dragVM.isSuccess = true
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal)
    }
}

#Preview {
    DragProgressBarView()
        .environment(\.locale, .init(identifier: "ko"))
}
