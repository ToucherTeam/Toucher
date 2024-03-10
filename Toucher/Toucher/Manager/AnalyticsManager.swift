//
//  TrackingManager.swift
//  Toucher
//
//  Created by bulmang on 2/23/24.
//

import Foundation
import FirebaseAnalytics
import FirebaseAnalyticsSwift

struct AnalyticsManager {
    
    static let shared = AnalyticsManager()
    private init() { }
    
    func logEvent(name: String, params: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
    
    func setUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func setUserProperty(value: String?, property: String) {
        Analytics.setUserProperty(value, forName: property)
    }
    
}
