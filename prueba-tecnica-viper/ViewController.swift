//
//  ViewController.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import UIKit
import FirebaseFirestore

struct Profile: Identifiable {
    let id: String
    let fullName: String
    let image: UIImage
}



class ViewController: UIViewController {
    
    // MARK: Realtime Database
    private let colorManager = ColorManager()
    private let colorView = UIView()
    private let nameLabel = UILabel()
    private let hexLabel = UILabel()
    
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
    
    // MARK: Firestore
    let db = Firestore.firestore()

    
    /// Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        UserDefaults.standard.set(false, forKey: "was-avatar-updated")
        
        // setupUI()
        setupColorManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchLastProfile()
        setupTableView()
    }
    
    
    private func setupUI() {
        // Configurar vista de color
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 16
        colorView.layer.shadowRadius = 8
        colorView.layer.shadowOpacity = 0.3
        view.addSubview(colorView)
        
        // Configurar labels
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        colorView.addSubview(nameLabel)
        
        hexLabel.translatesAutoresizingMaskIntoConstraints = false
        hexLabel.font = .systemFont(ofSize: 18, weight: .medium)
        hexLabel.textColor = .white
        hexLabel.textAlignment = .center
        colorView.addSubview(hexLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor, constant: -20),
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -16),
            
            hexLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            hexLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 16),
            hexLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -16)
        ])
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
            self.colorView.backgroundColor = color
            self.nameLabel.text = name
            self.hexLabel.text = color.hexString
            
            // Actualizar toda la app
            if let window = self.view.window {
                window.updateBackgroundColor(color) // color.withAlphaComponent(0.1)
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
        tableView.heightAnchor.constraint(equalToConstant: self.view.frame.width/2).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        view.addSubview(sendButton)
        sendButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
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
        
        print(" avatarData; \(avatarData) ")
        
        /*
        guard let imageData = avatarData.jpegData(compressionQuality: 0.5) else {
            
            return
        }
        */
        
        
        if avatarData.count > 1_048_576 { // Límite de 1MB de Firestore
            // self.errorMessage = "La imagen es demasiado grande para guardarla (máx 1MB)."
            print("La imagen es demasiado grande para guardarla (máx 1MB).")
            return
        }
        
        let imageBase64String = avatarData.base64EncodedString()
        
        
        
        // Guardar los datos en Firestore
        saveProfile(name: username, imageBase64: imageBase64String)
        
        
        // MARK: Firestore
        // let path: String = "avatar-images/\(username).png"
        
        /*
        storage.child(path).putData(avatarData, metadata: nil) { [weak self] _, error in
            guard error == nil else {
                return
            }
            self?.storage.child(path).downloadURL { [weak self] (url, error) in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print(" url-firestore ", urlString, "\n")
                UserDefaults.standard.set(urlString, forKey: "url-firestore")
                DispatchQueue.main.async {
                    Alert.showSuccessAlert(on: self!)
                    if let usernametextField = self?.view.viewWithTag(Constants.Tags.userNameInput) as? UITextField
                    {
                        usernametextField.text = ""
                    }
                }
            }
        }
        */
    }
    
    private func saveProfile(name: String, imageBase64: String) {
        let profileData: [String: Any] = [
            "fullName": name,
            "imageBase64": imageBase64,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("profiles").addDocument(data: profileData) { [weak self] error in
            if let error = error {
                // self?.errorMessage = "Error al guardar los datos: \(error.localizedDescription)"
                print("Error al guardar los datos: \(error.localizedDescription)")
            } else {
                //self?.isSuccess = true
                print(" Success ")
            }
        }
    }
    
    
    func fetchLastProfile() {
        db.collection("profiles")
            .order(by: "createdAt", descending: true)
            .limit(to: 1)
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    // self?.errorMessage = "Error al obtener el último perfil: \(error.localizedDescription)"
                    print("Error al obtener el último perfil: \(error.localizedDescription)")
                    return
                }
                
                // Asegurarse de que hay un documento
                guard let document = snapshot?.documents.first else {
                    self?.lastProfile = nil // No hay perfiles guardados
                    return
                }
                
                let data = document.data()
                let id = document.documentID
                let name = data["fullName"] as? String ?? "Sin nombre"
                
                // Decodificar la imagen desde Base64
                if let imageBase64 = data["imageBase64"] as? String,
                   let imageData = Data(base64Encoded: imageBase64),
                   let image = UIImage(data: imageData) {
                    
                    print(" \n\n name: \(name) \n\n ")
                    
                    DispatchQueue.main.async {
                        self?.lastProfile = Profile(id: id, fullName: name, image: image)
                    }
                }
            }
    }
    
    
    
}




extension UIWindow {
    func updateBackgroundColor(_ color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = color
            self.rootViewController?.view.backgroundColor = color
        }
    }
}




// MARK: - Delegate & Dataspurce UITableView

enum CustomSections: CaseIterable
{
    case avatar, userName, graph
    
    static func numberOfSections() -> Int
    {
        return self.allCases.count
    }
    
    static func getSection(_ section: Int) -> CustomSections
    {
        return self.allCases[section]
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomSections.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CustomSections.getSection(indexPath.row) {
        
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.avatarCell, for: indexPath)
            if let cell = cell as? AvatarCell {
                cell.setUpView()
                return cell
            }
        case .userName:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.usernameCell, for: indexPath)
            if let cell = cell as? UsernameCell {
                cell.setUpView()
                return cell
            }
        case .graph:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.graphCell, for: indexPath)
            if let cell = cell as? GraphCell {
                cell.setUpView()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch CustomSections.getSection(indexPath.row) {
        case .avatar:
            self.handleEventCamera()
        case .userName: break;
        case .graph:
            print(" Hacia las graficas.. ")
            //let detalle: UIViewController = GraphDetailViewController()
            //let nav = UINavigationController(rootViewController: detalle)
            //self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch CustomSections.getSection(indexPath.row) {
        case .avatar:
            return 90.0
        case .userName:
            return 45.0
        case .graph:
            return 45.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        let cornerRadius = Constants.Value.cornerRadius
        var corners: UIRectCorner = []

        if indexPath.row == 0
        {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
    }
    
    
}
