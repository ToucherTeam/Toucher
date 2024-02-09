//
//  user.swift
//  Toucher
//
//  Created by bulmang on 2/8/24.
//

import Foundation

struct User {
    var appLaunchTimestamp: [Date] {
        get {
            return UserDefaults.standard.object(forKey: "appLaunchTimestamp") as? [Date] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appLaunchTimestamp")
        }
    }
}
