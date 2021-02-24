//
//  WelcomeViewController.swift
//  Ios Game
//
//  Created by Martin on 2/1/21.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func onContinue(_ sender: Any) {
        
        if Auth.auth().currentUser != nil, let id = Auth.auth().currentUser?.uid {
            DataStore.shared.getUserWithId(id: id) {[weak self] ( user, error) in
                if let user = user {
                    DataStore.shared.localUser = user
                    self?.performSegue(withIdentifier: "homeSegue", sender: nil)
                }
            }
            return
        }
        
        
        DataStore.shared.continueWihtGuest  { [weak self] (user, error) in
            if let user = user {
                DataStore.shared.localUser = user
                self?.performSegue(withIdentifier: "homeSeque", sender: nil)
            }
        }
        
    }
    
}

func ShowErrorAlert() {
    let alert = UIAlertController(title: "Error", message: "\(username)", preferredStyle: .alert)
    
    
}
