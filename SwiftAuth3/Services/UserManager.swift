import Foundation

class UserManager {
    static let shared = UserManager() // Singleton
    private init() {}
    
    var currentUser: User? {
        didSet {
            // NotificationCenter ile veri güncellemesi
            NotificationCenter.default.post(name: .userDidUpdate, object: currentUser)
        }
    }
}

extension Notification.Name {
    static let userDidUpdate = Notification.Name("userDidUpdate")
}
