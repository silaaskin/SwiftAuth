import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func didUpdateUser(_ user: User)
}

class ProfileViewController: UIViewController {
    
    // YÖNTEM: Init
    let email: String
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    weak var delegate: ProfileViewControllerDelegate?
    var userClosure: ((User) -> Void)?
    
    // YÖNTEM: Property (didSet)
    private var currentUser: User? {
        didSet {
            guard let user = currentUser else { return }
            infoLabel.text = "Username: \(user.username)\nEmail: \(user.email)"
            didSetLabel.text = "didSet tetiklendi → UI guncellendi"
            didSetLabel.textColor = UIColor(red: 0.20, green: 0.78, blue: 0.56, alpha: 1)
        }
    }
    
    private let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .white
        return lbl
    }()
    
    private let didSetLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "didSet henuz tetiklenmedi"
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = UIColor(white: 1, alpha: 0.3)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.textColor = .white
        tf.keyboardAppearance = .dark
        tf.autocapitalizationType = .none
        tf.isHidden = true
        tf.backgroundColor = UIColor(white: 1, alpha: 0.07)
        tf.layer.cornerRadius = 12
        tf.attributedPlaceholder = NSAttributedString(string: "Yeni kullanici adi",
            attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.3)])
        return tf
    }()
    
    private let updateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Update Username", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        btn.backgroundColor = UIColor(red: 0.31, green: 0.27, blue: 0.90, alpha: 1)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.10, alpha: 1)
        title = "Profil"
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addSubview(infoLabel)
        view.addSubview(didSetLabel)
        view.addSubview(usernameField)
        view.addSubview(updateButton)
        
    
        
        updateButton.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(userDidUpdate(_:)),
            name: .userDidUpdate, object: nil)
        
        // ─────────────────────────────────────────────────────────
        // YÖNTEM: NotificationCenter — Settings'ten dil değişince dinle
        // ─────────────────────────────────────────────────────────
        NotificationCenter.default.addObserver(self,
            selector: #selector(languageChanged(_:)),
            name: .languageDidChange, object: nil)
        
        currentUser = UserManager.shared.currentUser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // YÖNTEM: Singleton — her açılışta dili buradan oku
        applyLanguage()
    }
    
    private func applyLanguage() {
        let isEnglish = UserManager.shared.language == "en"
        title = isEnglish ? "Profile" : "Profil"
        guard let user = currentUser else { return }
        infoLabel.text = isEnglish ?
            "Username: \(user.username)\nEmail: \(user.email)" :
            "Kullanici: \(user.username)\nEmail: \(user.email)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w = view.frame.size.width - 40
        infoLabel.frame     = CGRect(x: 20, y: 150, width: w, height: 60)
        didSetLabel.frame   = CGRect(x: 20, y: 215, width: w, height: 20)
        usernameField.frame = CGRect(x: 40, y: 255, width: w-40, height: 48)
        usernameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        usernameField.leftViewMode = .always
        updateButton.frame  = CGRect(x: 40, y: 315, width: w-40, height: 50)
        view.subviews.first(where: { ($0 as? UIButton)?.title(for: .normal) == "Ayarlar" })?
            .frame = CGRect(x: 40, y: 380, width: w-40, height: 46)
    }
    
    @objc func updateUser() {
        if usernameField.isHidden {
            usernameField.isHidden = false
            usernameField.becomeFirstResponder()
            updateButton.setTitle("Kaydet", for: .normal)
            return
        }
        
        guard var user = currentUser,
              let newName = usernameField.text,
              !newName.isEmpty else { return }
        
        user.username = newName
        currentUser = user
        UserManager.shared.currentUser = user
        userClosure?(user)
        delegate?.didUpdateUser(user)
        
        usernameField.text = ""
        usernameField.isHidden = true
        usernameField.resignFirstResponder()
        updateButton.setTitle("Update Username", for: .normal)
    }
    
    @objc func userDidUpdate(_ notification: Notification) {
        currentUser = notification.object as? User
    }
    
    // ─────────────────────────────────────────────────────────
    // YÖNTEM: NotificationCenter — Settings'ten dil bildirimi geldi
    // ─────────────────────────────────────────────────────────
    @objc func languageChanged(_ notification: Notification) {
        guard let lang = notification.userInfo?["lang"] as? String else { return }
        let isEnglish = lang == "en"
        title = isEnglish ? "Profile" : "Profil"
        guard let user = currentUser else { return }
        infoLabel.text = isEnglish ?
            "Username: \(user.username)\nEmail: \(user.email)" :
            "Kullanici: \(user.username)\nEmail: \(user.email)"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
