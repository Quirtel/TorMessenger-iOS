import UIKit
import MessageKit
import RealmSwift
import SwiftyUserDefaults

class DialogViewController: MessagesViewController {
    var messages: [MessageRealmObject] = []
    var currentSenderId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        let realmInstance = try! Realm()
        messages = realmInstance.objects(MessageRealmObject.self).compactMap {
            if $0.fromUserId == currentSenderId {
                return $0
            } else {
                return nil
            }
        }

        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
        }
    }
}

extension DialogViewController: MessagesDataSource {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> SenderType {
        return Sender(senderId: Defaults[\.username] ?? "null", displayName: Defaults[\.username] ?? "null")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension DialogViewController: MessagesDisplayDelegate {
    
}

extension DialogViewController: MessagesLayoutDelegate {
  func heightForLocation(message: MessageType,
    at indexPath: IndexPath,
    with maxWidth: CGFloat,
    in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
    return 0
  }
}
