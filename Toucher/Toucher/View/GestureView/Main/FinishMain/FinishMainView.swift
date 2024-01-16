//
//  FinishMainView.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

struct FinishMainView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    @StateObject private var viewModel = FinishMainViewModel()
    
    var body: some View {
        ZStack {
            Color.customBG1.ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(viewModel.gestures, id: \.rawValue) { gesture in
                        FinishMainButton(gesture: gesture, selectedGesture: viewModel.selectedGesture) {
                            viewModel.selectGesture(gesture: gesture)
                            withAnimation(.easeInOut(duration: 2)) {
                                proxy.scrollTo(gesture, anchor: .center)
                            }
                        }
                        .id(gesture)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 24)
                    }
                    .padding(.bottom, 180)
                    .overlay {
                        if !navigationManager.navigate {
                            if let selectedGesture = viewModel.selectedGesture {
                                if let index = viewModel.gestures.firstIndex(of: selectedGesture) {
                                    PracticeBubble(gesture: selectedGesture) {
                                        navigationManager.navigate = true
                                    }
                                    .offset(y: 10 + 95 * CGFloat(index + 1) + 32 * CGFloat(index))
                                    .frame(maxHeight: .infinity, alignment: .top)
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 80)
                }
            }
        }
        .overlay(alignment: .top) {
            Text("자유롭게 눌러 학습하세요!")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .foregroundColor(.customPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.leading, 40)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundStyle(Color.customBG0)
                        .shadow(color: .customShadow, radius: 10, y: 4)
                }
                .padding(.horizontal)
        }
        .navigationDestination(isPresented: $navigationManager.navigate) {
            if let selectedGesture = viewModel.selectedGesture {
                navigationManager.navigateGestureView(gesture: selectedGesture)
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FinishMainView()
    }
}
