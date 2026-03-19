import UIKit

class LoginViewController: UIViewController {
    
    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .none
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.text = "ali@test.com"
        tf.textColor = .white
        tf.keyboardAppearance = .dark
        tf.attributedPlaceholder = NSAttributedString(string: "Email",
            attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.3)])
        return tf
    }()
    
    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Sifre"
        tf.borderStyle = .none
        tf.isSecureTextEntry = true
        tf.text = "1234"
        tf.textColor = .white
        tf.keyboardAppearance = .dark
        tf.attributedPlaceholder = NSAttributedString(string: "Sifre",
            attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.3)])
        return tf
    }()
    
    private let generatedNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = UIColor(red: 0.49, green: 0.45, blue: 0.98, alpha: 1)
        return lbl
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Giris Yap", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.backgroundColor = UIColor(red: 0.31, green: 0.27, blue: 0.90, alpha: 1)
        btn.layer.cornerRadius = 14
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.10, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(emailField)
        view.addSubview(generatedNameLabel)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        
        // Alan arka planları
        for field in [emailField, passwordField] {
            field.backgroundColor = UIColor(white: 1, alpha: 0.07)
            field.layer.cornerRadius = 12
        }
        
        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        updateGeneratedName()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w = view.frame.size.width - 80
        emailField.frame         = CGRect(x: 40, y: 220, width: w, height: 48)
        emailField.leftView      = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        emailField.leftViewMode  = .always
        generatedNameLabel.frame = CGRect(x: 40, y: 273, width: w, height: 20)
        passwordField.frame      = CGRect(x: 40, y: 300, width: w, height: 48)
        passwordField.leftView   = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        passwordField.leftViewMode = .always
        loginButton.frame        = CGRect(x: 40, y: 370, width: w, height: 52)
    }
    
    // YÖNTEM: Method
    func generateUsername(from email: String) -> String {
        let parts = email.split(separator: "@")
        guard let first = parts.first else { return "kullanici" }
        return String(first)
    }
    
    @objc private func emailChanged() {
        updateGeneratedName()
    }
    
    private func updateGeneratedName() {
        let email = emailField.text ?? ""
        let name = generateUsername(from: email)
        generatedNameLabel.text = name.isEmpty ? "" : "Kullanici adi: \(name)"
    }
    
    @objc func loginTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else { return }
        
        let username = generateUsername(from: email)
        let user = User(username: username, email: email)
        
        UserManager.shared.currentUser = user
        
        // YÖNTEM: Init
        let profileVC = ProfileViewController(email: email)
        profileVC.userClosure = { updatedUser in
            print("Closure ile kullanici guncellendi: \(updatedUser.username)")
        }
        profileVC.delegate = self
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension LoginViewController: ProfileViewControllerDelegate {
    func didUpdateUser(_ user: User) {
        print("Delegate ile kullanici guncellendi: \(user.username)")
    }
}
