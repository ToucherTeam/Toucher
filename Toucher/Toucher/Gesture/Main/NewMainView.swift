//
//  NewMainView.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

struct NewMainView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    
    var body: some View {
        ZStack {
            Color.customBG1.ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(navigationManager.gestureButtons) { button in
                        MainButton(type: button.buttonType, gesture: button.gestureType) {
                            navigationManager.navigate = true
                        }
                        .disabled(button.buttonType != .ready)
                        .id(button.gestureType)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 24)
                    }
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 600)
                    }
                }
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 200)
                }
                .scrollIndicators(.hidden)
                .scrollDisabled(true)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        navigationManager.updateButtonTypes()
                    }
                }
                .onChange(of: navigationManager.headerGesture) { gesture in
                    withAnimation(.easeInOut(duration: 2)) {
                        proxy.scrollTo(gesture, anchor: .top)
                    }
                }
            }
            
            MainViewHeader(gesture: navigationManager.headerGesture)
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationDestination(isPresented: $navigationManager.navigate) {
            navigationManager.navigateGestureView(gesture: navigationManager.headerGesture)
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    NavigationStack {
        NewMainView()
    }
}
