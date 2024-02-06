//
//  ToucherApp.swift
//  Toucher
//
//  Created by hyunjun on 2023/08/31.
//

import SwiftUI

@main
struct ToucherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
