import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var previewText: UILabel!
    @IBOutlet weak var sentTime: UILabel!
    
    func configure(with model: ChatCellModel) {
        self.senderName.text = model.name
        self.previewText.text = model.lastMessageText
        self.previewText.text = model.sentTime
    }
}
