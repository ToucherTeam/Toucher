//
//  SceneDelegate.swift
//  Toucher
//
//  Created by hyunjun on 2/5/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
 
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    @AppStorage("isSignedIn") var isSignedIn = true
    private let firestoreManager = FirestoreManager.shared
    var window: UIWindow?
    
    /// AppDelegate SceneDelegate 연결
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        print("SceneDelegate is connected")
        signInAnonymously()
        if isSignedIn {
            firestoreManager.createUser()
            isSignedIn = false
        }
    }
    
    /// 앱이 켜졌을때, 백그라운드에서 돌아왔을 때
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("Scene did become active")
        firestoreManager.appendAppLaunchTimestamp()
    }
    
    /// 앱이 백그라운드로 돌아갔을때
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("scene will enter background")
        firestoreManager.appendTerminateTimestamp()
    }
    
    /// 앱이 종료되었을 때
    func sceneDidDisconnect(_ scene: UIScene) {
        print("Scene did disconnect")
        firestoreManager.appendTerminateTimestamp()
    }
}

extension SceneDelegate {
    private func signInAnonymously() {
        if let user = Auth.auth().currentUser {
            firestoreManager.getCurrentUser()
            print("Log in \(user.uid)")
        } else {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print("로그인 에러")
                    return
                }
                
                if let user = authResult?.user {
                    self.firestoreManager.createUser()
                    print("Sign in \(user.uid)")
                }
            }
        }
    }
}
