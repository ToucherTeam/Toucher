//
//  FinishMainView.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

struct FinishMainView: View {
    @StateObject private var viewModel = FinishMainViewModel()
    
    var body: some View {
        ZStack {
            Color.customBG1.ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(viewModel.gestures, id: \.rawValue) { gesture in
                        FinishMainButton(gesture: gesture, selectedGesture: viewModel.selectedGesture) {
                            viewModel.selectGesture(gesture: gesture)
                            withAnimation(.easeIn(duration: 3)) {
                                proxy.scrollTo(gesture, anchor: .top)
                            }
                        }
                        .id(gesture)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 24)
                    }
                    .overlay {
                        if let selectedGesture = viewModel.selectedGesture {
                            if let index = viewModel.gestures.firstIndex(of: selectedGesture) {
                                PracticeBubble(gesture: selectedGesture) {
                                    viewModel.selectedGesture = nil
                                }
                                .offset(y: 10 + 95 * CGFloat(index + 1) + 32 * CGFloat(index))
                                .frame(maxHeight: .infinity, alignment: .top)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 50)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 150)
                }
            }
        }
    }
}

#Preview {
    FinishMainView()
}
