//
//  DataStore+GameRequest.swift
//  Ios Game
//
//  Created by Martin on 2/3/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

extension DataStore {
    func startGameRequest(userId: String, completion: @escaping (_ request: GameRequest?, _ error: Error?) -> Void) {
        let requestRef = database.collection(FirebaseCollections.gameRequests.rawValue).document()
        let gameRequest = createGameRequest(toUser: userId, id: requestRef.documentID)
        do {
            try requestRef.setData(from: gameRequest, completion: { (error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                completion(gameRequest, nil)
            })
        } catch  {
            completion(nil, error)
        }
    }
    private func createGameRequest(toUser: String, id: String) -> GameRequest? {
        guard let localUserId = localUser?.id else { return nil }
        return GameRequest(id: id, from: localUserId,
                           to: toUser,
                           createdAt: Date().toMiliseconds(),
                           fromUserame: localUser?.username)
    }
    
    func checkForExistingGame(toUser: String,
                              fromUser: String,
                              completion: @escaping (_ exist: Bool, _ error: Error?) -> Void) {
        
        let gameRequest = database.collection (FirebaseCollections.gameRequests.rawValue)
            .whereField("from", isEqualTo: fromUser)
            .whereField("to", isEqualTo: toUser)
        
        gameRequest.getDocuments { (snapshot, error) in
            if let error = error {
                completion(false,error)
            }
            if let snapshot = snapshot, snapshot.documents.count > 0 {
                completion(true,nil)
                return
            }
            completion(false, nil)
        }
    }
    
    func setGameRequestListener() {
        if gameRequestListener != nil {
            removeGameRequestListener()
        }
        guard let localUserId = localUser?.id else { return }
        gameRequestListener = database
            .collection(FirebaseCollections.gameRequests.rawValue)
            .whereField("to", isEqualTo: localUserId)
            .addSnapshotListener({ (snapshot, error) in
                
            if let snapshot = snapshot, let document = snapshot.documents.first {
                do {
                    let gameRequest = try document.data(as: GameRequest.self)
                    NotificationCenter.default.post(name: Notification.Name("didReceiveGameRequestNotification"), object: nil, userInfo: ["GameRequest":gameRequest as Any])
                    print("New GameRequest with " + (gameRequest?.from ?? ""))
                } catch  {
                    print(error.localizedDescription)
                }
            }
        })
    }
    
   
    
    func removeGameRequestListener() {
        gameRequestListener?.remove()
        gameRequestListener = nil
    }
    func deleteGameRequest(gameRequest: GameRequest){
        let gameRequestRef = database
            .collection(FirebaseCollections.gameRequests.rawValue)
            .document(gameRequest.id)
        
        gameRequestRef.delete()
    }
}


