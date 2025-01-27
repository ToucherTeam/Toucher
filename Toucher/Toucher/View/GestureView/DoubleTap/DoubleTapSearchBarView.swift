//
//  DoubleTapSearchBarView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapSearchBarView: View {
    @StateObject private var doubleTapVM = DoubleTapViewModel()
    
    private let firestoreManager = FirestoreManager.shared
    private let selectedGuideVideo: URLManager = .doubleTapSearchBarView
    
    var body: some View {
        
        ZStack {
            BackGroundColor(isFail: doubleTapVM.isFail, isSuccess: doubleTapVM.isSuccess)
            
            VStack {
                CustomToolbar(title: "두 번 누르기", isSuccess: doubleTapVM.isSuccess, selectedGuideVideo: selectedGuideVideo)
                
                ZStack {
                    VStack {
                        Text(doubleTapVM.isSuccess ? "성공!\n" : doubleTapVM.isFail ? "조금만 더 빠르게\n두 번 눌러주세요!" : "검색창을 두 번\n눌러볼까요?")
                            .foregroundColor(doubleTapVM.isFail && !doubleTapVM.isSuccess ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .font(.customTitle)
                            .padding(.top, 40)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        HelpButton(selectedGuideVideo: selectedGuideVideo, style: doubleTapVM.isFail ? .primary : .secondary)
                            .opacity(doubleTapVM.isSuccess ? 0 : 1)
                            .animation(.easeInOut, value: doubleTapVM.isSuccess)
                    }
                    
                    searchBar
                        .padding(.bottom)
                        .overlay {
                            if doubleTapVM.isSuccess {
                                ConfettiView()
                            }
                        }
                }
                
            }
        }
        .analyticsScreen(name: "DoubleTapSearchBarView")
        .modifier(MoveToNextModifier(isNavigate: $doubleTapVM.isNavigate, isSuccess: $doubleTapVM.isSuccess))
        .navigationDestination(isPresented: $doubleTapVM.isNavigate) {
            DoubleTapImageView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .modifier(
            FirebaseViewModifier(
                isSuccess: doubleTapVM.isSuccess,
                viewName: .doubleTapSearchBarView
            )
        )
        .onAppear {
            doubleTapVM.reset()
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            Text("검색")
            Spacer()
            Image(systemName: "mic.fill")
        }
        .overlay {
            if doubleTapVM.isSuccess {
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Text("붙여넣기")
                        Image(systemName: "text.viewfinder")
                        Text("붙여넣기 및 이동")
                    }
                    .font(.callout)
                    .padding(8)
                    .padding(.horizontal, 4)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(.systemGray6))
                            .shadow(color: .gray.opacity(0.5), radius: 3)
                    }
                    
                    BubbleTail()
                        .frame(width: 20, height: 10)
                        .foregroundStyle(Color(.systemGray6))
                        .offset(x: -60, y: -1)
                        .shadow(color: .gray.opacity(0.3), radius: 1, y: 3)
                }
                .offset(x: -20, y: -50)
                .transition(.scale)
            }
        }
        .font(.title)
        .foregroundColor(.secondary)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .foregroundStyle(Color(.systemGray5).opacity(0.8))
        }
        .padding()
        .gesture(gesture)
    }
    
    private var gesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    doubleTapVM.isSuccess = true
                    doubleTapVM.isTapped = true
                }
                AnalyticsManager.shared.logEvent(name: "DoubleTapSearchBarView_ClearCount")
            }
            .exclusively(
                before: TapGesture()
                    .onEnded {
                        withAnimation {
                            doubleTapVM.isTapped = true
                            doubleTapVM.isFail = true
                        }
                        FirestoreManager.shared.updateViewTapNumber(.doubleTap, .doubleTapSearchBarView)
                        AnalyticsManager.shared.logEvent(name: "DoubleTapSearchBarView_Fail")
                    })
    }
}

struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.49994*width, y: 0.90437*height))
        path.addLine(to: CGPoint(x: 0.97684*width, y: 0.08254*height))
        path.addLine(to: CGPoint(x: 0.02305*width, y: 0.08254*height))
        path.addLine(to: CGPoint(x: 0.49994*width, y: 0.90437*height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    DoubleTapSearchBarView()
        .environment(\.locale, .init(identifier: "ko"))
}
