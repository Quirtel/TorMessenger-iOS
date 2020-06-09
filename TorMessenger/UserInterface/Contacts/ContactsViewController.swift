import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ContactsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var searchController = UISearchController(searchResultsController: nil)
    let disposeBag = DisposeBag()
    private var contactsContentProvider = ContentProvider()
    let formatter = RelativeDateTimeFormatter()
    var users: [UserRealmObject] = []
    var filteredUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
        setupSearchController()
        fetchContacts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearSearchResults()
    }
    
    func clearSearchResults() {
        filteredUsers.removeAll()
        fetchContacts()
        tableView.reloadData()
    }
    
    func fetchContacts() {
        let realm = try! Realm()
        users = realm.objects(UserRealmObject.self).compactMap {$0}
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        searchController.searchBar.rx.text
            .asDriver()
            .debounce(DispatchTimeInterval.milliseconds(2000))
            .drive(onNext: { str in
                if let str = str {
                    print(str)
                    if !str.isEmpty {
                        self.searchContacts(for: str)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func searchContacts(for username: String) {
        contactsContentProvider.fetchUser(shortAddress: username, onSuccess: { user in
            if let user = user {
                self.filteredUsers = [user]
                self.tableView.reloadData()
            }
        }, onError: { statusCode in
            DispatchQueue.main.async {
                self.clearSearchResults()
            }
        })
    }
}

extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")

        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "BasicCell")
        }
        
        if isFiltering {
            cell?.textLabel?.text = filteredUsers[indexPath.row].firstName
                + " " + (filteredUsers[indexPath.row].lastName ?? "")
            
            guard filteredUsers[indexPath.row].lastSeen != nil else {
                cell?.detailTextLabel?.text = "Last seen long ago"
                return cell!
            }
            
            if !filteredUsers[indexPath.row].lastSeen!.isEmpty {
                let date = Date(timeIntervalSince1970: Double(filteredUsers[indexPath.row].lastSeen!)!)
                cell?.detailTextLabel?.text = "Last seen \(formatter.localizedString(for: date, relativeTo: Date.init()))"
            }
        } else {
            cell?.textLabel?.text = users[indexPath.row].firstName
                + " " + (users[indexPath.row].lastName ?? "")
            
            guard users[indexPath.row].lastSeen != nil else {
                cell?.detailTextLabel?.text = "Last seen long ago"
                return cell!
            }
            
            if !users[indexPath.row].lastSeen!.isEmpty {
                let date = Date(timeIntervalSince1970: Double(users[indexPath.row].lastSeen!)!)
                cell?.detailTextLabel?.text = "Last seen \(formatter.localizedString(for: date, relativeTo: Date.init()))"
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dialogVC = DialogViewController()
        if isFiltering {
            dialogVC.currentSenderId = filteredUsers[indexPath.row].shortAddress
        } else {
            dialogVC.currentSenderId = users[indexPath.row].shortAddress
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(dialogVC, animated: true)
            dialogVC.shouldAddToContactsOnMessageSend = self.isFiltering
        }
    }
}

extension ContactsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchResults()
    }
}


extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    var isFiltering: Bool {
        guard searchController.searchBar.text != nil else {
            return false
        }
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
}
