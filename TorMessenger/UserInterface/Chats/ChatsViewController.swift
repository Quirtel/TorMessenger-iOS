import Foundation
import UIKit

class ChatsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
}


extension ChatsViewController: UITableViewDelegate {
    
}

extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}
