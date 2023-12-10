//
//  NewMainView.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

struct NewMainView: View {
    @StateObject private var viewModel = NewMainViewModel()
    
    var body: some View {
        ZStack {
            Color.customBG1.ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(viewModel.gestureButtons) { button in
                        MainButton(type: button.buttonType, gesture: button.gestureType) {
                            
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
                .onChange(of: viewModel.headerGesture) { gesture in
                    proxy.scrollTo(gesture, anchor: .top)
                }
            }
            
            MainViewHeader(gesture: viewModel.headerGesture)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    NewMainView()
}
