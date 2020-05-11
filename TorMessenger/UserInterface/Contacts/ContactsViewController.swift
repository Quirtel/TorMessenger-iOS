import UIKit

class ContactsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillLayoutSubviews() {
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil), animated: false)
    }
}

extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}

extension ContactsViewController: UITableViewDelegate {
    
}
