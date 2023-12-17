//
//  PanMap.swift
//  Toucher
//
//  Created by bulmang on 12/18/23.
//

import SwiftUI
import MapKit

struct PanMap: UIViewRepresentable {
    @Binding var heading: CLLocationDirection
    @Binding var centerCoordinate: CLLocationCoordinate2D

    private let distance: CLLocationDistance = 3000
    private let pitch: CGFloat = 0

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = true

        let camera = MKMapCamera(lookingAtCenter: centerCoordinate, fromDistance: distance, pitch: pitch, heading: heading)
        mapView.camera = camera

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.camera.heading = heading
        view.camera.centerCoordinate = centerCoordinate
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: PanMap

        init(_ parent: PanMap) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}

