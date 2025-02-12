//
//  FirebaseViewModifier.swift
//  Toucher
//
//  Created by Hyunjun Kim on 2/7/24.
//

import SwiftUI

struct FirebaseViewModifier: ViewModifier {
    private let firestoreManager = FirestoreManager.shared
    
    var isSuccess: Bool
    var viewName: ViewName
    var gesture: GestureType {
        switch viewName {
        case .doubleTapButtonView, .doubleTapSearchBarView, .doubleTapImageView:
            return .doubleTap
        case .longTapButtonView, .longTapCameraButtonView, .longTapAlbumPhotoView:
            return .longPress
        case .swipeCarouselView, .swipeListView, .swipeMessageView:
            return .swipe
        case .dragIconView, .dragProgressBarView, .dragAppIconView:
            return .drag
        case .panNotificationView, .panMapView:
            return .pan
        case .pinchIconZoomInView, .pinchIconZoomOutView, .pinchImageView:
            return .pinch
        case .rotateIconView, .rotateMapView:
            return .rotate
        }
    }
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                firestoreManager.updateViewTapNumber(gesture, viewName)
            }
            .onAppear {
                firestoreManager.updateViewTimeStamp(gesture, viewName)
            }
            .onDisappear {
                if isSuccess {
                    firestoreManager.updateViewClearData(gesture, viewName)
                } else {
                    firestoreManager.updateBackButtonData(gesture, viewName)
                }
            }
    }
}
