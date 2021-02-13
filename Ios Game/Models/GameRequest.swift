//
//  gameRequest.swift
//  Ios Game
//
//  Created by Martin on 2/3/21.
//

import Foundation


struct GameRequest: Codable {
    var id: String
    var from: String
    var to: String
    var createdAt: TimeInterval
    var fromUserame: String?
}

