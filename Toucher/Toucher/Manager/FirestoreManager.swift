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
            userCollection.document(userId).setData(["userID": userId]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func appendAppLaunchTimestamp() {
        if let userId = userId {
            userCollection.document(userId).updateData(["appLaunchTimestamp": FieldValue.arrayUnion([Date()])]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func appendTerminateTimestamp() {
        if let userId = userId {
            userCollection.document(userId).updateData(["appTerminateTimestamp": FieldValue.arrayUnion([Date()])]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
