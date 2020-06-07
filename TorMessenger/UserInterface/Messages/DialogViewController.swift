import UIKit
import MessageKit
import RealmSwift
import SwiftyUserDefaults
import InputBarAccessoryView

class DialogViewController: MessagesViewController {
    var messages: [MessageRealmObject] = []
    var currentSenderId = ""
    var userId = Defaults[\.username] ?? "null"
    
    let refreshControl = UIRefreshControl()
    let contentProvider = ContentProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        configureMessageCollectionView()
        loadMoreMessages()
    }
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    @objc func loadMoreMessages() {
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
        }
        contentProvider.getMessages { [weak self] _ in
            guard let weakSelf = self else { return }
            let realmInstance = try! Realm()
            weakSelf.messages = realmInstance.objects(MessageRealmObject.self).compactMap {
                if $0.fromUserId == weakSelf.currentSenderId || $0.toUserId == weakSelf.currentSenderId {
                    return $0
                } else {
                    return nil
                }
            }
            DispatchQueue.main.async {
                weakSelf.messagesCollectionView.reloadData()
                weakSelf.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
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
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        .zero
    }
}

extension DialogViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
        at indexPath: IndexPath,
        with maxWidth: CGFloat,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension DialogViewController: MessageCellDelegate {
    
}

extension DialogViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        contentProvider.sendMessage(toUserId: currentSenderId, text: text) {
            inputBar.inputTextView.text = ""
            self.loadMoreMessages()
        }
    }
}
