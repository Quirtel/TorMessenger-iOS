import Foundation
import UIKit
import Reusable
import RealmSwift

class ChatsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var chats: [MessageRealmObject] = []
    var users: [User]?
    
    let searchController = UISearchController(searchResultsController: nil)
    let refreshController = UIRefreshControl()
    let contentProvider = ContentProvider()
    
    override func viewDidLoad() {
        tableView.register(cellType: ChatCell.self)
        navigationItem.searchController = searchController
        refreshController.addTarget(self, action: #selector(fetchMessages), for: .valueChanged)
        tableView.refreshControl = refreshController
        fetchMessages()
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil), animated: false)
    }
    
    @objc private func fetchMessages() {
        DispatchQueue.main.async {
            self.refreshController.beginRefreshing()
        }
        contentProvider.getMessages { [weak self] messages in
            guard let weakSelf = self else { return }
            weakSelf.chats = messages
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
            }
        }
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
        }
    }
}


extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dialogVC = DialogViewController()
        dialogVC.currentSenderId = chats[indexPath.row].fromUserId
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
        let model = ChatCellModel(name: chats[indexPath.row].fromUserId,
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
