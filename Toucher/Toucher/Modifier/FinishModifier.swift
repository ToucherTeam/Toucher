//
//  FinishModifier.swift
//  Toucher
//
//  Created by Hyunjun Kim on 1/4/24.
//

import SwiftUI

struct FinishModifier: ViewModifier {
    @StateObject private var navigationManager = NavigationManager.shared
    
    @Binding var isNavigate: Bool
    @Binding var isSuccess: Bool
    
    func body(content: Content) -> some View {
        content.onChange(of: isSuccess) { _ in
            if isSuccess {
                HapticManager.notification(type: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    navigationManager.navigate = false
                    navigationManager.updateGesture()
                }
            }
        }
    }
}
