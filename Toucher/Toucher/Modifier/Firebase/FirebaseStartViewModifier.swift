//
//  FirebaseStartViewModifier.swift
//  Toucher
//
//  Created by Hyunjun Kim on 2/7/24.
//

import SwiftUI

struct FirebaseStartViewModifier: ViewModifier {
    private let firestoreManager = FirestoreManager.shared
    
    @Binding var create: Bool
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
            .onAppear {
                if create {
                    firestoreManager.createTotal(gesture)
                    firestoreManager.updateTotalTimeStamp(gesture)
                                        
                    for index in 0..<viewNames(for: gesture).count {
                        firestoreManager.createView(gesture, viewNames(for: gesture)[index])
                    }
                    
                    firestoreManager.updateViewTimeStamp(gesture, viewName)
                    
                    create = false
                } else {
                    firestoreManager.updateViewTimeStamp(gesture, viewName)
                }
            }
            .onDisappear {
                if isSuccess {
                    firestoreManager.updateViewClearData(gesture, viewName)
                } else {
                    firestoreManager.updateBackButtonData(gesture, viewName)
                }
            }
    }
    
    func viewNames(for gestureType: GestureType) -> [ViewName] {
        switch gestureType {
        case .doubleTap:
            return [.doubleTapButtonView, .doubleTapSearchBarView, .doubleTapImageView]
        case .longPress:
            return [.longTapButtonView, .longTapCameraButtonView, .longTapAlbumPhotoView]
        case .swipe:
            return [.swipeCarouselView, .swipeListView, .swipeMessageView]
        case .drag:
            return [.dragIconView, .dragProgressBarView, .dragAppIconView]
        case .pan:
            return [.panNotificationView, .panMapView]
        case .pinch:
            return [.pinchIconZoomInView, .pinchIconZoomOutView, .pinchImageView]
        case .rotate:
            return [.rotateIconView, .rotateMapView]
        }
    }
}
