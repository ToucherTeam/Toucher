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
            
            VStack {
                ForEach(viewModel.gestureButtons) { button in
                    MainButton(type: button.buttonType, gesture: button.gestureType) {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    NewMainView()
}
