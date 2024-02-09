//
//  PanPracticeView.swift
//  Toucher
//
//  Created by hyunjun on 2023/11/06.
//

import SwiftUI
import CoreLocation

struct PanMapView: View {
    @StateObject private var panVM = PanViewModel()
    
    private let selectedGuideVideo: URLManager = .panMapView
    
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
                
                Text(panVM.isSuccess ? "성공!" : "사방으로 움직여\n지도를 이동해보세요.")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.customTitle)
                    .padding(.vertical, 40)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .background {
                        Rectangle()
                            .foregroundColor(.customWhite.opacity(0.7))
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                VStack {
                    Spacer()
                    
                    HelpButton(selectedGuideVideo: selectedGuideVideo, style: panVM.isFail ? .primary : .secondary)
                        .opacity(panVM.isSuccess ? 0 : 1)
                        .animation(.easeInOut, value: panVM.isSuccess)
                }
            }
            .overlay {
                if panVM.isSuccess {
                    ConfettiView()
                }
            }
            .modifier(FinishModifier(isNavigate: $panVM.isNavigate, isSuccess: $panVM.isSuccess))
            .modifier(
                FirebaseEndViewModifier(
                    isSuccess: panVM.isSuccess,
                    viewName: .panMapView
                )
            )
            .onAppear {
                panVM.reset()
            }
        }
    }
}

#Preview {
    PanMapView()
        .environment(\.locale, .init(identifier: "ko"))
}
