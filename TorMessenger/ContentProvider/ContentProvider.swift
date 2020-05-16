import Foundation
import RealmSwift
import Moya
import RxSwift
import SwiftyUserDefaults

final class ContentProvider {
    private var usersProvider = MoyaProvider<UsersAPI>()
    private var messagesProvider = MoyaProvider<MessagesAPI>()
    private var disposeBag = DisposeBag()
    private var realmQueue = DispatchQueue(label: "RealmQueue")
    
    func fetchUser(shortAddress: String,
                    completion: @escaping (User?) -> ()) throws {
        requestWithTokenCheck() {
            self.usersProvider.rx.request(.getUserInformation(parameter: shortAddress),
                                          callbackQueue: DispatchQueue.global()).subscribe { event in
                switch event {
                case .success(let response):
                    let user = User.init(JSONString: try! response.mapString())
                    DispatchQueue.main.async {
                        completion(user)
                    }
                case .error(let error):
                    print(error)
                    break
                }
            }.disposed(by: self.disposeBag)
        }
    }
    
    func register(user: User, completion: @escaping (User?) -> ()) throws {
        usersProvider.rx.request(.register(userParameter: user), callbackQueue: DispatchQueue.global()).subscribe { event in
            switch event {
            case .success(let response):
                let user = User.init(JSONString: try! response.mapString())
                DispatchQueue.main.async {
                    completion(user)
                }
            case .error(let error):
                print(error)
                break
            }
        }.disposed(by: disposeBag)
    }
    
    func authenticate(auth: Auth, completion: (() -> ())?) {
        
    }
    
    func getMessages(completion: @escaping ([MessageRealmObject]) -> ()) {
        requestWithTokenCheck() {
            self.messagesProvider.rx.request(.retrieve).subscribe { event in
                var messageDatabaseObjects: [MessageRealmObject] = []
                let realm = try! Realm()
                
                switch event {
                case .success(let response):
                    let messages = [Message].init(JSONString: try! response.mapString())
                    messages?.forEach { msg in
                        messageDatabaseObjects.append(MessageRealmObject(with: msg))
                    }
                    
                    try! realm.write {
                        realm.add(messageDatabaseObjects)
                    }
                case .error(let error):
                    print(error)
                    break
                }
                
                messageDatabaseObjects.removeAll()
                messageDatabaseObjects = realm.objects(MessageRealmObject.self)
                    .sorted(byKeyPath: "sentTime", ascending: false)
                    .distinct(by: ["fromUserId"]).map {$0}
                
                DispatchQueue.main.async {
                    completion(messageDatabaseObjects)
                }
            }.disposed(by: self.disposeBag)
        }
    }
    
    func sendMessage(messageObject: Message, completion: @escaping () -> ()) {
        requestWithTokenCheck() {
            self.messagesProvider.rx.request(.send,
                                          callbackQueue: DispatchQueue.global()).subscribe { event in
                switch event {
                case .success(_):
                    DispatchQueue.main.async {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(MessageRealmObject(with: messageObject))
                        }
                        completion()
                    }
                case .error(let error):
                    print(error)
                    break
                }
            }.disposed(by: self.disposeBag)
        }
    }
    
    private func requestWithTokenCheck(completionHandler: (() -> ())?) {
        guard Defaults[\.username] != nil else {
            return
        }
        
        let timeNow = Int(Date.init().timeIntervalSince1970)
        
        let tokenExpirationDate = Int(Defaults[\.tokenExpirationDate]) ?? 0
        let auth = Auth(login: Defaults[\.username]!, passwordHash: Defaults[\.passwordHash]!)
        
        if tokenExpirationDate + 3600 <= timeNow  {
            usersProvider.rx.request(.auth(credentials: auth), callbackQueue: DispatchQueue.global()).subscribe { event in
                switch event {
                case .success(let context):
                    let credentials = BearerToken(JSONString: try! context.mapString())!
                    Defaults[\.authToken] = credentials.token
                    Defaults[\.tokenExpirationDate] = String(credentials.expirationDate)
                    completionHandler?()
                case .error(let error):
                    print(error)
                    break
                }
            }.disposed(by: disposeBag)
        } else {
            completionHandler?()
        }
    }
    
}
