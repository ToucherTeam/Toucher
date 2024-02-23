//
//  HelpButton.swift
//  Toucher
//
//  Created by Hyunjun Kim on 11/28/23.
//

import SwiftUI

enum HelpButtonStyle {
    case primary
    case secondary
}

struct HelpButton: View {
    @State private var animate = false
    @State private var isFullScreenPresented = false
    
    private let firestoreManager = FirestoreManager.shared
    
    var selectedGuideVideo: URLManager
    var style: HelpButtonStyle
    
    var gesture: GestureType {
        switch selectedGuideVideo {
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
    var viewName: ViewName {
        switch selectedGuideVideo {
        case .doubleTapButtonView:
            return .doubleTapButtonView
        case .doubleTapSearchBarView:
            return .doubleTapSearchBarView
        case .doubleTapImageView:
            return .doubleTapImageView
        case .longTapButtonView:
            return .longTapButtonView
        case .longTapCameraButtonView:
            return .longTapCameraButtonView
        case .longTapAlbumPhotoView:
            return .longTapAlbumPhotoView
        case .swipeCarouselView:
            return .swipeCarouselView
        case .swipeListView:
            return .swipeListView
        case .swipeMessageView:
            return .swipeMessageView
        case .dragIconView:
            return .dragIconView
        case .dragProgressBarView:
            return .dragProgressBarView
        case .dragAppIconView:
            return .dragAppIconView
        case .panNotificationView:
            return .panNotificationView
        case .panMapView:
            return .panMapView
        case .pinchIconZoomInView:
            return .pinchIconZoomInView
        case .pinchIconZoomOutView:
            return .pinchIconZoomOutView
        case .pinchImageView:
            return .pinchImageView
        case .rotateIconView:
            return .rotateIconView
        case .rotateMapView:
            return .rotateMapView
        }
    }
    
    private var textColor: Color {
        withAnimation {
            switch style {
            case .primary:
                return .customBG1
            case .secondary:
                return .customSecondary
            }
        }
    }
    
    private var backgroundColor: Color {
        withAnimation {
            switch style {
            case .primary:
                return .customPrimary
            case .secondary:
                return .customBG2
            }
        }
    }
    
    var body: some View {
        Button {
            isFullScreenPresented.toggle()
            firestoreManager.updateHelpButtonData(gesture, viewName)
            AnalyticsManager.shared.logEvent(name: "\(viewName)_HelpButtonCount")
        } label: {
            Text("도움이 필요하신가요?")
                .font(.customButton)
                .foregroundStyle(textColor)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(backgroundColor)
                }
                .frame(width: UIScreen.main.bounds.width - 32)
                .padding(.horizontal, 16)
                .offset(y: animate ? -8 : 0)
                .onChange(of: style) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 2).repeatForever()) {
                            animate = true
                        }
                    }
                }
        }
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            GuideView(selectedGuideVideo: selectedGuideVideo, isFullScreenPresented: $isFullScreenPresented)
        }
    }
}
