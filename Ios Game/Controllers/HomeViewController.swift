//
//  HomeViewController.swift
//  Ios Game
//
//  Created by Martin on 2/1/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {

   
    
    @IBOutlet weak var tableView: UITableView!

    var loadingView: LoadingView?
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = " Welcome" + (DataStore.shared.localUser?.username ?? "")
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveGameRequest(_:)), name: Notification.Name("didReceiveGameRequestNotification"), object: nil)
        setupTable()
        getUser()
        
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataStore.shared.setUsersListener { [weak self] in
            self?.getUser()
        }
        DataStore.shared.setGameRequestListener()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DataStore.shared.removeUsersListener()
        DataStore.shared.removeGameRequestListener()
    }
    
    
    private func setupTable(){
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
    @objc private func didReceiveGameRequest(_ notification: Notification ) {
        guard let userInfo = notification.userInfo as? [String:GameRequest] else { return }
        guard let gameRequest = userInfo["GameRequest"] else { return }
            
        
        let fromUsername = gameRequest.fromUserame ?? ""
        
        
        let alert = UIAlertController(title: "GameRequest",
                                      message: "\(fromUsername) invited you for a game",
                                      preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Accept", style: .default) { _ in
            self.declineRequest(gameRequest:gameRequest)
        }
        
        let decline = UIAlertAction(title: "Decline", style: .cancel) { _ in
            self.declineRequest(gameRequest:gameRequest)
        }
        
        alert.addAction(accept)
        alert.addAction(decline)
        
        present(alert, animated: true, completion: nil)
        
        }
    private func declineRequest (gameRequest: GameRequest) {
        DataStore.shared.deleteGameRequest(gameRequest: gameRequest)
    }
}




extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.setData(user: user)
        cell.delegate = self
        return cell
        
    }
}

extension HomeViewController: UserCellDelegate {
    func requestGameWith(user: User) {
        guard let userId = user.id,
              let localUser = DataStore.shared.localUser,
              let localUserId = localUser.id else { return }
        
        DataStore.shared.checkForExistingGame(toUser: userId, fromUser: localUserId) { (exists, error) in
            if let error = error {
                print(error.localizedDescription)
                print("Error checking for game, try again later")
                return
            }
            if !exists {
                DataStore.shared.startGameRequest(userId: userId) { [ weak self ] (request,error) in
                    if request != nil {
                        DataStore.shared.setGameRequestListener()
                        self?.setupLoadingView(me: localUser, opponent: user)
                    }
                    
            }
        }
            
    }
}
    private func getUser() {
        DataStore.shared.getAllUsers { [weak self] (users,error) in
            guard let self = self else { return }
            if let users = users{
                self.users = users.filter({$0.id != DataStore.shared.localUser?.id })
                self.tableView.reloadData()
            }
        }
       
            DataStore.shared.setGameRequestListener()
        }
      
    }


extension HomeViewController {
    
    func setupLoadingView (me: User, opponent: User) {
        if loadingView != nil {
            loadingView?.removeFromSuperview()
            loadingView = nil
        }
        loadingView = LoadingView(me:me, opponent: opponent)
        view.addSubview(loadingView!)
        loadingView?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    func hideLoadingView () {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
