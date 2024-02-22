//
//  TrackingManager.swift
//  Toucher
//
//  Created by bulmang on 2/23/24.
//

import Foundation

struct AnalyticsManager {
    
    private init() { }

    struct Screen {
        private init() { }

        static let splash = "스플래시"
        static let onboarding = "온보딩_진입"
        static let main = "메인화면_진입"
    }

    struct Event {
        private init() { }

        static let touchOnboardingStart = "A2_온보딩_시작"
        static let touchKakaoLogin = "A3_로그인_카카오"
        static let touchAppleLogin = "A3_로그인_애플"
    }
}
