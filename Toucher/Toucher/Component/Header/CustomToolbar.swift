//
//  File.swift
//  Toucher
//
//  Created by bulmang on 12/10/23.
//

import SwiftUI

struct CustomToolbar: View {
    @Environment(\.dismiss) var dismiss
    
    let title: LocalizedStringKey
    
    var isSuccess = false
    var selectedGuideVideo: URLManager
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
    
    var body: some View {
        
            HStack {
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.customGR1)
                    .frame(maxWidth: .infinity)
            }
            .frame(width: UIScreen.main.bounds.width)
            .overlay(alignment: .leading) {
                Button {
                    dismiss()
                    AnalyticsManager.shared.logEvent(name: "\(viewName)BackButtonCount")
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                        Text("이전으로")
                            .font(.system(size: 17))
                            .fontWeight(.regular)
                    }
                    .foregroundColor(.accentColor)
                }
                .padding(.leading, 8)
                .disabled(isSuccess)
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.customGR3)
            }
        }
}

#Preview {
    CustomToolbar(title: "두번 누르기", selectedGuideVideo: .doubleTapButtonView)
}
