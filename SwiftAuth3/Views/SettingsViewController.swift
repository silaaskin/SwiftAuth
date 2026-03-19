import UIKit

class SettingsViewController: UIViewController {
    
    // YÖNTEM: Init — currentUser ProfileVC'den geçirildi
    private let currentUser: User?
    
    init(currentUser: User?) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private let userInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let languageSegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Türkçe", "English"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Ayarlar"
        
        view.addSubview(userInfoLabel)
        view.addSubview(languageSegment)
        
        // Mevcut dil seçimini göster
        languageSegment.selectedSegmentIndex = UserManager.shared.language == "en" ? 1 : 0
        
        languageSegment.addTarget(self, action: #selector(languageChanged), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(userDidUpdate(_:)),
            name: .userDidUpdate, object: nil)
        
        refreshUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w = view.frame.size.width - 40
        userInfoLabel.frame   = CGRect(x: 20, y: 160, width: w, height: 60)
        languageSegment.frame = CGRect(x: 20, y: 240, width: w, height: 40)
    }
    
    func refreshUI() {
        if let user = UserManager.shared.currentUser {
            userInfoLabel.text = "Kullanıcı: \(user.username)\nEmail: \(user.email)"
        }
    }
    
    @objc func languageChanged(_ sender: UISegmentedControl) {
        // ─────────────────────────────────────────────────────
        // YÖNTEM: Singleton — dil tercihini merkeze kaydet
        // Her ekran viewWillAppear'da buradan okuyacak
        // ─────────────────────────────────────────────────────
        UserManager.shared.language = sender.selectedSegmentIndex == 0 ? "tr" : "en"
    }
    
    @objc func userDidUpdate(_ notification: Notification) {
        refreshUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
