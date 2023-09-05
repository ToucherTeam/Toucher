//
//  DeviceManager.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/01.
//

import SwiftUI

class DeviceManager {
    // 싱글톤 인스턴스
    static let shared = DeviceManager()
    
    private init() {} // 외부에서 생성자 호출 방지
    
    func iPhoneSE() -> Bool {
        let screenHeight = UIScreen.main.bounds.size.height
        return screenHeight <= 670.0
    }
}
