//
//  NavigationManager.swift
//  Toucher
//
//  Created by hyunjun on 12/11/23.
//

import SwiftUI

@MainActor
final class NavigationManager: ObservableObject {
    @Published var navigate = false
    
    @Published var gestureButtons: [GestureButton] = [
        GestureButton(buttonType: .ready, gestureType: .doubleTap),
        GestureButton(buttonType: .none, gestureType: .longPress),
        GestureButton(buttonType: .none, gestureType: .swipe),
        GestureButton(buttonType: .none, gestureType: .drag),
        GestureButton(buttonType: .none, gestureType: .pan),
        GestureButton(buttonType: .none, gestureType: .pinch),
        GestureButton(buttonType: .none, gestureType: .rotate)
    ]
    @Published var headerGesture: GestureType = .doubleTap
    
    @AppStorage("savedGesture") private var savedGesture: GestureType = .doubleTap
    @AppStorage("finish") private var finish = false
    
    static let shared = NavigationManager()
    
    private init() { }
    
    @ViewBuilder func navigateGestureView(gesture: GestureType) -> some View {
        switch gesture {
        case .doubleTap:
            DoubleTapButtonView()
        case .longPress:
            LongTapButtonView()
        case .swipe:
            SwipeCarouselView()
        case .drag:
            DragIconView()
        case .pan:
            PanNotificationView()
        case .pinch:
            PinchIconZoomInView()
        case .rotate:
            RotateIconView()
        }
    }
    
    func updateGesture() {
        if let index = gestureButtons.firstIndex(where: { $0.buttonType == .ready }) {
            if index + 1 < self.gestureButtons.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        self.gestureButtons[index + 1].buttonType = .ready
                        self.gestureButtons[index].buttonType = .done
                        self.updateGestureData()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    withAnimation {
                        self.finish = true
                    }
                }
            }
        }
    }
    
    /// 저장된 제스처를 불러옵니다
    func loadSavedGesture() {
        for index in gestureButtons.indices {
            if gestureButtons[index].gestureType == savedGesture {
                gestureButtons[index].buttonType = .ready
                headerGesture = savedGesture
                break
            }
            gestureButtons[index].buttonType = .done
        }
    }

    /// 재스쳐 학습이 완료된 후 데이터를 업데이트 시킵니다
    private func updateGestureData() {
        if let readyGestureButton = gestureButtons.first(where: { $0.buttonType == .ready }) {
            headerGesture = readyGestureButton.gestureType
            savedGesture = readyGestureButton.gestureType
        } else {
            print("조건을 충족하는 요소를 찾을 수 없습니다.")
        }
    }
}
