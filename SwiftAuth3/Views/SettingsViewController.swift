import UIKit

class SettingsViewController: UIViewController {
    
    private let userInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(userInfoLabel)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidUpdate(_:)),
                                               name: .userDidUpdate,
                                               object: nil)
        
        refreshUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userInfoLabel.frame = CGRect(x: 20, y: 200, width: view.frame.size.width-40, height: 80)
    }
    
    func refreshUI() {
        if let user = UserManager.shared.currentUser {
            userInfoLabel.text = "Settings - User: \(user.username)"
        }
    }
    
    @objc func userDidUpdate(_ notification: Notification) {
        refreshUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
