//
//  DoubleTapPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapPracticeView1: View {
    
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var isFail = false
    @State private var navigate = false
    
    var body: some View {
        
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "두 번 누르기")
                
                Text(isSuccess ? "성공!\n" : isFail ? "조금만 더 빠르게\n두 번 눌러주세요!" : "검색창을 두 번\n눌러볼까요?")
                    .foregroundColor(isFail && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                
                searchBar
                    .frame(maxHeight: .infinity)
                    .padding(.bottom)
                    .overlay {
                        if isSuccess {
                            ConfettiView()
                        }
                    }
                
                HelpButton(style: isFail ? .primary : .secondary) {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
            }
        }
        .onChange(of: isSuccess) { _ in
            if isSuccess {
                HapticManager.notification(type: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    navigate = true
                }
            }
        }
        .navigationDestination(isPresented: $navigate) {
            DoubleTapPracticeView2()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            reset()
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
                .frame(width: isSuccess ? 600 : 0, height: 50)
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
    
    private func reset() {
        isTapped = false
        isSuccess = false
        isFail = false
    }
    
    private var gesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    isSuccess = true
                    isTapped = true
                }
            }
            .exclusively(
                before: TapGesture()
                    .onEnded {
                        withAnimation {
                            isTapped = true
                            isFail = true
                        }
                    })
    }
}

struct DoubleTapPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTapPracticeView1()
    }
}
