//
//  RotateMap.swift
//  Toucher
//
//  Created by hyunjun on 12/11/23.
//

import SwiftUI
import MapKit

struct RotateMap: UIViewRepresentable {
    @Binding var heading: CLLocationDirection
    
    private let center = CLLocationCoordinate2D(latitude: 37.57605, longitude: 126.97723)
    private let distance: CLLocationDistance = 3000
    private let pitch: CGFloat = 0
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false
        
        mapView.camera = MKMapCamera(lookingAtCenter: center, fromDistance: distance, pitch: pitch, heading: heading)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.camera.heading = heading
    }
}

#Preview {
    RotateMapView()
}
