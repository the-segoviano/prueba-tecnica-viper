//
//  ViewController.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Services
    private let firestoreService = FirestoreService()
    private let colorManager = ColorManager()
    
    var lastProfile: Profile?
    
    // MARK: - Scope
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.IdForCell.genericCell)
        tableView.register(UsernameCell.self, forCellReuseIdentifier: Constants.IdForCell.usernameCell)
        tableView.register(AvatarCell.self, forCellReuseIdentifier: Constants.IdForCell.avatarCell)
        tableView.register(GraphCell.self, forCellReuseIdentifier: Constants.IdForCell.graphCell)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    lazy var sendButton: UIButton = {
        let button = BaseButton.standardButton(withTitle: Constants.Strings.send)
        button.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        UserDefaults.standard.set(false, forKey: "was-avatar-updated")
        
        setupColorManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchLastProfile()
        setupTableView()
    }
    
    
    private func setupColorManager() {
        colorManager.accentColorDidChange = { [weak self] color, name in
            DispatchQueue.main.async {
                self?.updateUI(with: color, name: name)
            }
        }
        colorManager.startListeningForAccentColor()
    }
    
    private func updateUI(with color: UIColor, name: String) {
        UIView.animate(withDuration: 0.1) {
            if let window = self.view.window {
                window.updateBackgroundColor(color)
            }
        }
    }
    
    
    deinit {
        colorManager.stopListening()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = self.tableView.frame.height
        let contentHeight   = self.tableView.contentSize.height
        let centeringInset  = (tableViewHeight - contentHeight) / 2.0
        let topInset        = max(centeringInset, 0.0)
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    
    // MARK: - Custom Setup
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        view.addSubview(sendButton)
        sendButton.widthAnchor.constraint(equalToConstant: self.view.frame.width - 24).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: Constants.Value.htButton).isActive = true
        sendButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }
    
    
    @objc private func sendRequest(){
        var username: String = ""
        if let usernametextField = view.viewWithTag(Constants.Tags.userNameInput) as? UITextField {
            username = usernametextField.text!
            if username.isEmpty == true {
                Alert.showIncompleteFormAlert(on: self)
                return
            }
            if username.isValidInput() == false {
                Alert.showWrongFormatUsernameAlert(on: self)
                return
            }
        }
        
        if !UserDefaults.standard.bool(forKey: "was-avatar-updated") {
            Alert.showPickupANewImageAlert(on: self)
            return
        }
        
        UserDefaults.standard.set(username, forKey: "username")
        
        guard let avatarData = UserDefaults.standard.data(forKey: "avatar") else {
            return
        }
        
        if avatarData.count > 1_048_576 { // Límite de 1MB de Firestore
            Alert.show(title: "Error", message: "La imagen es demasiado grande para guardarla (máx 1MB).", on: self)
            return
        }
        
        let imageBase64String = avatarData.base64EncodedString()
        
        // Guardar los datos en Firestore
        firestoreService.saveProfile(name: username, imageBase64: imageBase64String) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                Alert.show(title: "Error", message: "Error al guardar los datos: \(error.localizedDescription)", on: self)
            } else {
                Alert.show(title: "Success", message: "Perfil guardado con éxito.", on: self)
            }
        }
    }
    
    func fetchLastProfile() {
        firestoreService.fetchLastProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                print("profile: \(profile)")
                self.lastProfile = profile
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error al obtener el último perfil: \(error.localizedDescription)")
                self.lastProfile = nil
            }
        }
    }
}
