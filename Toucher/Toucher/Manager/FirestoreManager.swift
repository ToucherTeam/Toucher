//
//  FirestoreManager.swift
//  Toucher
//
//  Created by hyunjun on 2/5/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager {
    static let shared = FirestoreManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("User")
    private(set) var userId: String?
        
    func getCurrentUser() {
        if let user = Auth.auth().currentUser {
            userId = user.uid
        }
    }
    
    func createUser() {
        if let userId = userId {
            let data: [String: Any] = [
                "userID": userId,
                "appLaunchTimestamp": [Date()]
            ]
            let userDocument = userCollection.document(userId)
            
            userDocument.setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                print("create user!")
            }
        }
    }
    
    func updateAppLaunchTimestamp() {
        if let userId = userId {
            let userDocument = userCollection.document(userId)
            
            userDocument.updateData(["appLaunchTimestamp": FieldValue.arrayUnion([Date()])]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateTerminateTimestamp() {
        if let userId = userId {
            let userDocument = userCollection.document(userId)

            userDocument.updateData(["appTerminateTimestamp": FieldValue.arrayUnion([Date()])]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: Total 관련 데이터 업로드
extension FirestoreManager {
    func createTotal(_ gesture: GestureType) {
        if let userId = userId {
            let data: [String: Any] = [
                "userId": userId,
                "totalId": gesture.rawValue,
                "totalClearNumber": 0
            ]
            
            let totalDocument = userCollection.document(userId).collection(gesture.rawValue).document(gesture.rawValue)
            
            totalDocument.setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateTotalTimeStamp(_ gesture: GestureType) {
        if let userId = userId {
            let totalDocument = userCollection.document(userId).collection(gesture.rawValue).document(gesture.rawValue)

            totalDocument.updateData(["totalTimeStamp": FieldValue.arrayUnion([Date()])]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateTotalClearData(_ gesture: GestureType) {
        if let userId = userId {
            let totalDocument = userCollection.document(userId).collection(gesture.rawValue).document(gesture.rawValue)
                        
            totalDocument.getDocument { document, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let document = document, document.exists {
                    if let data = document.data() {
                        let totalTimeStamp = data["totalTimeStamp"] as? [Timestamp] ?? []
                        var totalClearNumber = data["totalClearNumber"] as? Int ?? 0
                        var totalClearTime = 0
                        
                        if let lastTimeStamp = totalTimeStamp.last?.dateValue() {
                            print(lastTimeStamp)
                            totalClearTime = Int(Date().timeIntervalSince(lastTimeStamp))
                        }
                        totalClearNumber += 1
                        
                        let clearData: [String: Any] = [
                            "totalClearTime": FieldValue.arrayUnion([totalClearTime]),
                            "totalClearNumber": totalClearNumber
                        ]
                        
                        totalDocument.updateData(clearData)
                    }
                }
            }
        }
    }
}

// MARK: View 관련 데이터 업로드
extension FirestoreManager {
    func createView(_ gesture: GestureType, _ viewName: ViewName) {
        if let userId = userId {
            let data: [String: Any] = [
                "totalId": gesture.rawValue,
                "viewId": viewName.rawValue,
                "viewClearNumber": 0,
                "viewTapNumber": 0,
                "viewHelpButtonCount": 0
            ]
            
            let viewDocument = userCollection.document(userId).collection(gesture.rawValue).document(gesture.rawValue).collection(viewName.rawValue).document(viewName.rawValue)
            
            viewDocument.setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateViewTimeStamp(_ gesture: GestureType, _ viewName: ViewName) {
        if let userId = userId {
            let viewDocument = userCollection.document(userId).collection(gesture.rawValue).document(gesture.rawValue).collection(viewName.rawValue).document(viewName.rawValue)

            viewDocument.updateData(["viewTimeStamp": FieldValue.arrayUnion([Date()])])
        }
    }
    
        func updateViewTapNumber(_ gesture: GestureType, _ viewName: ViewName) {
            if let userId = userId {
                let viewDocument = userCollection.document(userId).collection(gesture.rawValue).document(gesture.rawValue).collection(viewName.rawValue).document(viewName.rawValue)
                
                viewDocument.getDocument { document, error in
                    if let document = document, document.exists {
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        var viewTapNumber = document.data()?["viewTapNumber"] as? Int ?? 0
                        
                            viewTapNumber += 1
                            let updatedData: [String: Any] = [
                                "viewTapNumber": viewTapNumber
                            ]
                            
                            viewDocument.updateData(updatedData)
                    }
                }
            }
        }

    func updateViewClearData(_ gesture: GestureType, _ viewName: ViewName) {
        if let userId = userId {
            let viewDocument = userCollection.document(userId).collection(gesture.rawValue).document(gesture.rawValue).collection(viewName.rawValue).document(viewName.rawValue)
            
            viewDocument.getDocument { document, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let document = document, document.exists {
                    if let data = document.data() {
                        let viewTimeStamp = data["viewTimeStamp"] as? [Timestamp] ?? []
                        var viewClearNumber = data["viewClearNumber"] as? Int ?? 0
                        var viewClearTime = 0
                        
                        if let lastTimeStamp = viewTimeStamp.last?.dateValue() {
                            print(lastTimeStamp)
                            viewClearTime = Int(Date().timeIntervalSince(lastTimeStamp))
                        }
                        viewClearNumber += 1
                        
                        let clearData: [String: Any] = [
                            "viewClearTime": FieldValue.arrayUnion([viewClearTime]),
                            "viewClearNumber": viewClearNumber
                        ]
                        
                        viewDocument.updateData(clearData)
                    }
                }
            }
        }
    }
    
    func updateBackButtonData(_ gesture: GestureType, _ viewName: ViewName) {
        if let userId = userId {
            let viewDocument = userCollection.document(userId).collection(gesture.rawValue).document(gesture.rawValue).collection(viewName.rawValue).document(viewName.rawValue)
            
            viewDocument.getDocument { document, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let document = document, document.exists {
                    if let data = document.data() {
                        var viewBackButtonCount = data["viewBackButtonCount"] as? Int ?? 0
                        viewBackButtonCount += 1
                        
                        let backButtonData: [String: Any] = [
                            "viewBackButtonTimeStamp": FieldValue.arrayUnion([Date()]),
                            "viewBackButtonCount": viewBackButtonCount
                        ]
                        
                        viewDocument.updateData(backButtonData)
                    }
                }
            }
        }
    }
    
    func updateHelpButtonData(_ gesture: GestureType, _ viewName: ViewName) {
        if let userId = userId {
            let viewDocument = userCollection.document(userId).collection(gesture.rawValue).document(gesture.rawValue).collection(viewName.rawValue).document(viewName.rawValue)
                        
            viewDocument.getDocument { document, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let document = document, document.exists {
                    if let data = document.data() {
                        var viewHelpButtonCount = data["viewHelpButtonCount"] as? Int ?? 0
                        viewHelpButtonCount += 1
                        
                        let helpButtonData: [String: Any] = [
                            "viewHelpButtonTimeStamp": FieldValue.arrayUnion([Date()]),
                            "viewHelpButtonCount": viewHelpButtonCount
                        ]
                        
                        viewDocument.updateData(helpButtonData)
                    }
                }
            }
        }
    }
}

/// rawValue 를 가지고 있는 enum 추가
enum ViewName: String {
    case doubleTapButtonView
    case doubleTapSearchBarView
    case doubleTapImageView
    case longTapButtonView
    case longTapCameraButtonView
    case longTapAlbumPhotoView
    case swipeCarouselView
    case swipeListView
    case swipeMessageView
    case dragIconView
    case dragProgressBarView
    case dragAppIconView
    case panNotificationView
    case panMapView
    case pinchIconZoomInView
    case pinchIconZoomOutView
    case pinchImageView
    case rotateIconView
    case rotateMapView
}
