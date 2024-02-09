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
            if doubleTapVM.isFail && !doubleTapVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "두 번 누르기", isSuccess: doubleTapVM.isSuccess)
                
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
        .overlay(
            Image("paste_bar")
                .resizable()
                .scaledToFit()
                .frame(width: doubleTapVM.isSuccess ? 600 : 0, height: 50)
                .offset(x: -20, y: -45)
        )
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
            }
            .exclusively(
                before: TapGesture()
                    .onEnded {
                        withAnimation {
                            doubleTapVM.isTapped = true
                            doubleTapVM.isFail = true
                        }
                    })
    }
}

#Preview {
    DoubleTapSearchBarView()
        .environment(\.locale, .init(identifier: "ko"))
}
