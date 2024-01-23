//
//  URLManager.swift
//  Toucher
//
//  Created by bulmang on 1/22/24.
//

import Foundation

enum URLManager {
    case doubleTapButtonView
    case doubleTapSearchBarView
    case doubleTapImageView
    case longTapButtonView
    case longTapCameraButtonView
    case longTapAlbumPhotoView
    case swipeCarouselView
    case swipeListView
    case swipeMessageView
    case dragIconView
    case dragProgressBarView
    case dragAppIconView
    case panNotificationView
    case panMapView
    case pinchIconZoomInView
    case pinchIconZoomOutView
    case pinchImageView
    case rotateIconView
    case rotateMapView
    
    var videoURL: String {
        switch self {
        case .doubleTapButtonView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/DoubleTap%2FDoubleTapButtonView.mp4?alt=media&token=0408642f-206f-493b-b53c-036b7dea6415"
        case .doubleTapSearchBarView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/DoubleTap%2FDoubleTapSearchBarView.mp4?alt=media&token=b58a66a7-9f87-4568-b4e8-a0200c187ed6"
        case .doubleTapImageView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/DoubleTap%2FDoubleTapImageView.mp4?alt=media&token=d8f1ffca-8b86-497b-a4cf-bd73dfa88267"
        case .longTapButtonView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/LongTap%2FLongTapButtonView.mp4?alt=media&token=6f7565d0-44f0-4b48-a43a-cd9742748be6"
        case .longTapCameraButtonView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/LongTap%2FLongTapCameraButtonView.mp4?alt=media&token=4af5a634-175b-4349-9670-66c94d4e8597"
        case .longTapAlbumPhotoView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/LongTap%2FLongTapAlbumPhotoView.mp4?alt=media&token=b8aa6f5a-1b77-4028-90c3-4d3c519cb66b"
        case .swipeCarouselView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Swipe%2FSwipeCarouselView.mp4?alt=media&token=b1179d4b-a285-4daf-84dc-8151afa462a3"
        case .swipeListView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Swipe%2FSwipeListView.mp4?alt=media&token=f529ab87-9a20-4fb5-bf1c-564b5899c052"
        case .swipeMessageView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Swipe%2FSwipeMessageView.mp4?alt=media&token=662c1007-f271-4050-9101-1bcf9ece437f"
        case .dragIconView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Drag%2FDragIconView.mp4?alt=media&token=6ff73bd6-70d2-46f4-99ea-a17afc67fd97"
        case .dragProgressBarView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Drag%2FDragProgressBarView.mp4?alt=media&token=333c76e4-7f0d-49cb-a348-b6d09f21e260"
        case .dragAppIconView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Drag%2FDragAppIconView.mp4?alt=media&token=6ce953cd-52c4-4c9c-8dc2-a50e6d64d05a"
        case .panNotificationView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Pan%2FPanNotificationView.mp4?alt=media&token=7e1dc833-87ab-4c32-a14b-59437290b371"
        case .panMapView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Pan%2FPanMapView.mp4?alt=media&token=bb454256-0bdf-4593-b48f-355edd64990f"
        case .pinchIconZoomInView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Pinch%2FPinchIconZoomInView.mp4?alt=media&token=040500f9-b706-4b17-9936-2cb93ca54bdb"
        case .pinchIconZoomOutView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Pinch%2FPinchIconZoomOutView.mp4?alt=media&token=d6c4035d-b440-4e12-a267-dbad00a8f89b"
        case .pinchImageView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Pinch%2FPinchImageView.mp4?alt=media&token=ff04c687-1f03-4694-b87d-235a001c9ae6"
        case .rotateIconView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Rotate%2FRotateIconView.mp4?alt=media&token=aa3d5a47-0807-4164-a6ef-b8b46486e69b"
        case .rotateMapView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-a4597.appspot.com/o/Rotate%2FRotateMapView.mp4?alt=media&token=4e7b23bf-8c3f-4af6-97a9-623df36647fa"
        }
    }
}
