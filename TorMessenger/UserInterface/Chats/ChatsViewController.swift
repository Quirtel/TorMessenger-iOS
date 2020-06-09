import Foundation
import UIKit
import Reusable
import RealmSwift
import SwiftyUserDefaults

class ChatsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [String: MessageRealmObject] = [:]
    var chats: [MessageRealmObject] = []
    var users: [String: UserRealmObject] = [:]
    var userNames: [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    let refreshController = UIRefreshControl()
    let contentProvider = ContentProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: ChatCell.self)
        navigationItem.searchController = searchController
        refreshController.addTarget(self, action: #selector(fetchMessages), for: .valueChanged)
        tableView.refreshControl = refreshController
        fetchMessages()
    }
    
    override func viewWillLayoutSubviews() {
    }
    
    @objc private func fetchMessages() {
        messages.removeAll()
        chats.removeAll()
        DispatchQueue.main.async {
            self.refreshController.beginRefreshing()
        }
        contentProvider.getMessages { [weak self] messages in
            guard let weakSelf = self else { return }
            messages.forEach { msg in
                if msg.fromUserId == Defaults[\.username] {
                    if let chatMsg = weakSelf.messages[msg.toUserId] {
                        weakSelf.messages[msg.toUserId] = max(chatMsg, msg)
                    } else {
                        weakSelf.messages[msg.toUserId] = msg
                    }
                }
                if msg.toUserId == Defaults[\.username] {
                    if let chatMsg = weakSelf.messages[msg.fromUserId] {
                        weakSelf.messages[msg.fromUserId] = max(chatMsg, msg)
                    } else {
                        weakSelf.messages[msg.fromUserId] = msg
                    }
                }
            }
            weakSelf.chats = weakSelf.messages.values.compactMap { $0 }
            weakSelf.userNames = weakSelf.messages.keys.compactMap { $0 }
            DispatchQueue.global().async {
                weakSelf.fetchUsers()
            }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
            }
        }
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
        }
    }
    
    private func fetchUsers() {
        contentProvider.fetchMultipleUsers(userNames: userNames, onSuccess: { result in
            let realm = try! Realm()
            var users: [String: UserRealmObject] = [:]
            for user in result {
                users.updateValue(UserRealmObject(with: user), forKey: user.shortAddress)
            }
            try! realm.write {
                realm.add(users.values.compactMap {$0}, update: .all)
            }
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, onError: { statusCode in
            
        })
    }
}


extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dialogVC = DialogViewController()
        if chats[indexPath.row].fromUserId == Defaults[\.username] {
            dialogVC.currentSenderId = chats[indexPath.row].toUserId
        } else {
            dialogVC.currentSenderId = chats[indexPath.row].fromUserId
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(dialogVC, animated: true)
        }
    }
}

extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ChatCell
        var senderId = ""
        if chats[indexPath.row].fromUserId == Defaults[\.username] {
            senderId = chats[indexPath.row].toUserId
        } else {
            senderId = chats[indexPath.row].fromUserId
        }
        
        let senderNameAndLastName = (users[senderId]?.firstName ?? senderId) + " " + (users[senderId]?.lastName ?? "")
        
        let model = ChatCellModel(name: senderNameAndLastName,
                                  lastMessageText: chats[indexPath.row].text,
                                  sentTime: chats[indexPath.row].sentTime)
        cell.configure(with: model)
        
        return cell as UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}

extension ChatsViewController: NibReusable {}
