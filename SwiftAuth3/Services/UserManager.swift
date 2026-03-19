import Foundation

class UserManager {
    static let shared = UserManager()
    private init() {}
    
    var currentUser: User? {
        didSet {
            NotificationCenter.default.post(name: .userDidUpdate, object: currentUser)
        }
    }
    
    var language: String = "tr" {
        didSet {
            NotificationCenter.default.post(name: .languageDidChange, object: language)
        }
    }
}

extension Notification.Name {
    static let userDidUpdate = Notification.Name("userDidUpdate")
    static let languageDidChange = Notification.Name("languageDidChange")
}
