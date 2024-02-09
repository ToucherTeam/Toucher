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
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/DoubleTapButtonView.mp4?alt=media&token=da5fce51-11e9-4c2a-9e45-1d6c9d1e4bd5"
        case .doubleTapSearchBarView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/DoubleTapSearchBarView.mp4?alt=media&token=2d17af3b-543e-48f2-8b27-1f12a8c2b3dd"
        case .doubleTapImageView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/DoubleTapImageView.mp4?alt=media&token=1cd288ea-1391-49f5-bbf8-02f684980a00"
        case .longTapButtonView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/LongTapButtonView.mp4?alt=media&token=d7bf3f0e-f880-4906-8725-3662b7e85d52"
        case .longTapCameraButtonView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/LongTapCameraButtonView.mp4?alt=media&token=fef8da0f-12b2-4c7b-b3a2-69e6fa436798"
        case .longTapAlbumPhotoView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/LongTapAlbumPhotoView.mp4?alt=media&token=a06a0a0e-bffc-4923-b773-2d824574fc82"
        case .swipeCarouselView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/SwipeCarouselView.mp4?alt=media&token=e34688fb-295c-42d8-8cfc-849b27a1db88"
        case .swipeListView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/SwipeListView.mp4?alt=media&token=6dae523f-39e4-4def-9426-f136d240e581"
        case .swipeMessageView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/SwipeMessageView.mp4?alt=media&token=3a97441e-3e9c-49f8-a0b7-c1dd5e3f8935"
        case .dragIconView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/DragIconView.mp4?alt=media&token=9269c986-76ef-4c55-beb1-a7d5ce431ce1"
        case .dragProgressBarView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/DragProgressBarView.mp4?alt=media&token=071923e0-71df-4d2e-b026-98a9a66d4617"
        case .dragAppIconView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/DragAppIconView.mp4?alt=media&token=f0dfa2f4-1b3d-4946-a0eb-d9894162372e"
        case .panNotificationView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/PanNotificationView.mp4?alt=media&token=cbcc4273-b108-4a2d-91fb-5097f76872b6"
        case .panMapView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/PanMapView.mp4?alt=media&token=e9c20862-5728-482c-98b5-3412abc577e6"
        case .pinchIconZoomInView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/PinchIconZoomInView.mp4?alt=media&token=26d1799c-b46b-423b-8543-d6ad7c86a018"
        case .pinchIconZoomOutView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/PinchIconZoomOutView.mp4?alt=media&token=a9da5502-91f0-4316-b35b-8ee867fcac52"
        case .pinchImageView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/PinchImageView.mp4?alt=media&token=375e6b03-013c-4a34-b907-2e4b9ac642c5"
        case .rotateIconView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/RotateIconView.mp4?alt=media&token=9e3c1c39-a211-41ab-ae64-7d18ba5dd014"
        case .rotateMapView:
            return "https://firebasestorage.googleapis.com/v0/b/toucher-3cce8.appspot.com/o/RotateMapView.mp4?alt=media&token=70e37777-366f-4577-9375-250816e4a250"
        }
    }
}
