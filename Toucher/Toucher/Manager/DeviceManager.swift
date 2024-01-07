//
//  DeviceManager.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/01.
//

import SwiftUI

class DeviceManager {
    static let shared = DeviceManager()
    
    private init() {}
    
    func iPhoneSE() -> Bool {
        let screenHeight = UIScreen.main.bounds.size.height
        return screenHeight <= 670.0
    }
}
