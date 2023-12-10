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
            
            ScrollView {
                ForEach(viewModel.gestureButtons) { button in
                    MainButton(type: button.buttonType, gesture: button.gestureType) {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 30)
            }
        }
    }
}

#Preview {
    FinishMainView()
}
