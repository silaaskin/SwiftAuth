import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func didUpdateUser(_ user: User)
}

class ProfileViewController: UIViewController {
    
    weak var delegate: ProfileViewControllerDelegate?
    var userClosure: ((User) -> Void)?
    
    private let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Enter new username"
        return tf
    }()
    
    private let updateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Update Username", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        view.addSubview(infoLabel)
        view.addSubview(usernameField)
        view.addSubview(updateButton)
        
        updateButton.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        
        // NotificationCenter ile veri güncellemesini dinle
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidUpdate(_:)),
                                               name: .userDidUpdate,
                                               object: nil)
        refreshUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoLabel.frame = CGRect(x: 20, y: 150, width: view.frame.size.width-40, height: 80)
        usernameField.frame = CGRect(x: 40, y: 250, width: view.frame.size.width-80, height: 40)
        updateButton.frame = CGRect(x: 40, y: 310, width: view.frame.size.width-80, height: 50)
    }
    
    func refreshUI() {
        if let user = UserManager.shared.currentUser {
            infoLabel.text = "Username: \(user.username)\nEmail: \(user.email)"
            usernameField.text = user.username // mevcut kullanıcı adını göster
        }
    }
    
    @objc func updateUser() {
        guard var user = UserManager.shared.currentUser else { return }
        guard let newName = usernameField.text, !newName.isEmpty else { return }
        
        user.username = newName
        UserManager.shared.currentUser = user
        
        // Closure ile güncelleme
        userClosure?(user)
        
        // Delegate ile güncelleme
        delegate?.didUpdateUser(user)
        
        // UI’yi güncelle
        refreshUI()
    }
    
    @objc func userDidUpdate(_ notification: Notification) {
        refreshUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
