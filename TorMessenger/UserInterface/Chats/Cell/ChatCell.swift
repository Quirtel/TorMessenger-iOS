import UIKit
import Reusable

class ChatCell: UITableViewCell, NibReusable {
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var previewText: UILabel!
    @IBOutlet weak var sentTime: UILabel!
    
    func configure(with model: ChatCellModel) {
        senderName.text = model.name
        previewText.text = model.lastMessageText
        let date = Date(timeIntervalSince1970: Double(model.sentTime)!)
        let formatter = RelativeDateTimeFormatter()
        sentTime.text = formatter.localizedString(for: date, relativeTo: Date.init())
    }
}
