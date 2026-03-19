import UIKit

class LoginViewController: UIViewController {
    
    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        usernameField.frame = CGRect(x: 40, y: 200, width: view.frame.size.width-80, height: 40)
        emailField.frame = CGRect(x: 40, y: 250, width: view.frame.size.width-80, height: 40)
        loginButton.frame = CGRect(x: 40, y: 310, width: view.frame.size.width-80, height: 50)
    }
    
    @objc func loginTapped() {
        guard let username = usernameField.text, !username.isEmpty,
              let email = emailField.text, !email.isEmpty else { return }
        
        let user = User(username: username, email: email)
        
        // Singleton ve NotificationCenter kullanımı
        UserManager.shared.currentUser = user
        
        // Closure yöntemi ile veri aktarımı
        let profileVC = ProfileViewController()
        profileVC.userClosure = { updatedUser in
            print("Closure ile kullanıcı güncellendi: \(updatedUser.username)")
        }
        
        // Delegate yöntemi
        profileVC.delegate = self
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

// MARK: - Delegate
extension LoginViewController: ProfileViewControllerDelegate {
    func didUpdateUser(_ user: User) {
        print("Delegate ile kullanıcı güncellendi: \(user.username)")
    }
}
