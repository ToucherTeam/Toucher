//
//  NetworkManager.swift
//  Toucher
//
//  Created by bulmang on 2/9/24.
//

import Foundation
import Network

final class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
