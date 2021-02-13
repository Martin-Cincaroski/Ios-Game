//
//  User.swift
//  Ios Game
//
//  Created by Martin on 2/1/21.
//

import Foundation

let avatars = ["avatarOne", "avatarTwo", "avatarThree "]

struct User: Codable {
    
    var id: String?
    var username: String?
    var avatarImage: String?
    
//    init (id: String, usermame: String, avatarImage: String) {
//        self.id = id
//        self.username = usermame
//        self.avatarImage = avatarImage
//    }
    static func createUser(id: String, username: String) -> User {
        var user = User()
        user.id = id
        user.username = username
        user.avatarImage = avatars.randomElement()
        return user
    }
    
    mutating func setRandomImage() {
        self.avatarImage = avatars.randomElement()
    }
}
