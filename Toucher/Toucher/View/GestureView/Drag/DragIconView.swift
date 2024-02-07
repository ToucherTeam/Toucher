//
//  DragIconView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct DragIconView: View {
    @AppStorage("createDrag") var createDrag = true
    @StateObject private var dragVM = DragViewModel()
    
    @State private var isArrived = false
    @State private var offset: CGSize = .zero
    @State private var scale = 1.0
    
    @Namespace var circle
    
    private let selectedGuideVideo: URLManager = .dragIconView
    
    var body: some View {
        ZStack {
            if dragVM.isFail && !dragVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "끌어오기", isSuccess: dragVM.isSuccess)
                
                ZStack {
                    VStack {
                        Text(dragVM.isSuccess ? "성공!" : dragVM.isFail ? "꾹 누른 상태로 옮겨주세요." : dragVM.isTapped ? "아래 원으로 옮겨보세요" : "캐릭터를 꾹 눌러 볼까요?")
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
                    
                    ZStack {
                        ZStack {
                            Image("drag_asset")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120)
                                .zIndex(-1)
                            if dragVM.isSuccess {
                                Image("ToucherCharacter")
                                    .resizable()
                                    .scaledToFit()
                                    .matchedGeometryEffect(id: "circle", in: circle)
                                    .frame(width: 100)
                                    .foregroundColor(.green)
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        if !dragVM.isSuccess {
                            Image("ToucherCharacter")
                                .resizable()
                                .scaledToFit()
                                .matchedGeometryEffect(id: "circle", in: circle)
                                .frame(width: 100 * scale)
                                .foregroundStyle(.gray.opacity(0.5))
                                .offset(offset)
                                .frame(maxHeight: .infinity, alignment: .top)
                                .zIndex(1)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            let start = value.startLocation
                                            let trans = value.translation
                                            
                                            offset = CGSize(width: start.x + trans.width - 100/2,
                                                            height: start.y + trans.height - 100/2)
                                            withAnimation(.easeInOut) {
                                                scale = 1.2
                                                dragVM.isTapped = true
                                            }
                                        }
                                        .onEnded { value in
                                            if  UIScreen.main.bounds.height * 0.2...UIScreen.main.bounds.height * 0.5 ~= value.translation.height &&
                                                    -30...30 ~= value.translation.width {
                                                isArrived = true
                                            }
                                            
                                            if isArrived {
                                                withAnimation {
                                                    dragVM.isSuccess = true
                                                }
                                            }
                                            
                                            if !isArrived {
                                                withAnimation(.easeInOut) {
                                                    offset = .zero
                                                    scale = 1.2
                                                    dragVM.isTapped = false
                                                    dragVM.isFail = true
                                                }
                                            }
                                        }
                                        .simultaneously(with: LongPressGesture(minimumDuration: 0)
                                            .onEnded { _ in
                                                withAnimation {
                                                    scale = 1.2
                                                    dragVM.isTapped = true
                                                }
                                            }
                                        )
                                )
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .overlay {
                        if dragVM.isSuccess {
                            ConfettiView()
                        }
                    }
                    .background {
                        if dragVM.isTapped && !dragVM.isSuccess {
                            Arrows()
                                .rotationEffect(.degrees(270))
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.53)
                    .offset(y: UIScreen.main.bounds.height * 0.04)
                }
            }
        }
        .modifier(MoveToNextModifier(isNavigate: $dragVM.isNavigate, isSuccess: $dragVM.isSuccess))
        .navigationDestination(isPresented: $dragVM.isNavigate) {
            DragProgressBarView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .modifier(
            FirebaseStartViewModifier(
                create: $createDrag,
                isSuccess: dragVM.isSuccess,
                viewName: .dragIconView
            )
        )
        .onAppear {
            dragVM.reset()
            isArrived = false
            offset = .zero
            scale = 1.0
        }
    }
}

#Preview {
    DragIconView()
        .environment(\.locale, .init(identifier: "ko"))
}
