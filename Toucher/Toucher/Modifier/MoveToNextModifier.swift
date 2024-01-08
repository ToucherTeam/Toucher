//
//  MoveToNextModifier.swift
//  Toucher
//
//  Created by Hyunjun Kim on 1/4/24.
//

import SwiftUI

struct MoveToNextModifier: ViewModifier {
    @Binding var isNavigate: Bool
    @Binding var isSuccess: Bool

    func body(content: Content) -> some View {
        content.onChange(of: isSuccess) { _ in
            if isSuccess {
                HapticManager.notification(type: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    isNavigate = true
                }
            }
        }
    }
}
