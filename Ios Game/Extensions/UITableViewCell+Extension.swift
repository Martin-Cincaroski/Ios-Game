//
//  UITableViewCell-Extension.swift
//  Ios Game
//
//  Created by Martin on 2/3/21.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
