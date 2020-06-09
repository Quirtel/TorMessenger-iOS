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
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        if Date.init().distance(to: date) < 86400 {
            formatter.dateFormat = "HH:mm"
        }
        
        sentTime.text = formatter.string(from: date)
    }
}
