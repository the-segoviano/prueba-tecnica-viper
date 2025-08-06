//
//  Helpers.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit

struct Constants {
    
    struct Strings {
        static let ok = "ok"
        static let cancel = "Cancelar"
        static let send = "Enviar"
        static let username = "nombre del usuario"
        static let close = "Cerrar"
    }
    
    
    struct Value {
        static let htTextField: CGFloat = 48.0
        static let htButton: CGFloat = 40.0
        static let leadingMar: CGFloat = 16.0  // Or Left Margin
        static let trailingMar: CGFloat = -16.0 // Or Right Margin
        static let padding: CGFloat = 8.0
        static let cornerRadius: CGFloat = 15.0
        static let sizeProductImage: CGFloat = 30.0
        static let sizeIconHeart: CGFloat = 24.0
    }
    
    
    
    struct Tags {
        static let userNameInput = 1357911
    }
    
    struct ImageName {
        static let avatar: String = "avatar"
    }
    
    struct IdForCell {
        static let genericCell: String = "GenericCell"
        static let usernameCell: String = "UsernameCell"
        static let avatarCell: String = "AvatarCell"
        static let graphCell: String = "GraphCell"
        static let chartTableViewCell: String = "ChartTableViewCell"
        
    }
    
}

class Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.ok, style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc,
                       with: "Campo vacío",
                       message: "El campo del nombre de usuario requiere de un valor.")
    }
    
    static func showWrongFormatUsernameAlert(on vc: UIViewController) {
        showBasicAlert(on: vc,
                       with: "Caracteres no válidos",
                       message: "Solo se aceptan caracteres álfabeticos")
    }
    
    static func showPickupANewImageAlert(on vc: UIViewController) {
        showBasicAlert(on: vc,
                       with: "Seleccione una imagen diferente",
                       message: "")
    }
    
    static func showSuccessAlert(on vc: UIViewController) {
        showBasicAlert(on: vc,
                       with: "Éxito!",
                       message: "Su imagen fue guardada.")
    }
    

}

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError(" Error to initialize ")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}


class CustomTextField {
    
    class func getTextField(withPlaceholder placeholder: String = "") -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.Value.cornerRadius
        field.addBorder(borderColor: UIColor.lightGray, widthBorder: 1.0)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.placeholder = placeholder
        if #available(iOS 13.0, *) {
            field.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
        return field
    }
    
}


class BaseButton {
    
    class func standardButton(withTitle title: String) -> UIButton {
        let button = BaseButton.getButton(withTitle: title, withColor: .systemBlue)
        return button
    }
    
    static func getButton(withTitle title: String, withColor color: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.Value.cornerRadius
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        return button
    }
    
}


class ChartTableViewCell: BaseTableViewCell {
    
    /*
    func setupView(with question: Question, with colors: [String]) {
        let titleLabelChart: UILabel = UILabel()
        titleLabelChart.translatesAutoresizingMaskIntoConstraints = false
        titleLabelChart.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabelChart.text = question.text
        titleLabelChart.textAlignment = .center
        titleLabelChart.numberOfLines = 0
        
        addSubview(titleLabelChart)
        titleLabelChart.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        titleLabelChart.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        titleLabelChart.heightAnchor.constraint(equalToConstant: 45).isActive = true
        titleLabelChart.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        let pieChartView = PieChartView()
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        var labelledSegments: [LabelledSegment] = [LabelledSegment](), i: Int = 0
        question.chartData.forEach {
            labelledSegments.append(
                LabelledSegment(color: UIColor(hexString: colors[i]),
                                name: $0.text,
                                value: CGFloat($0.percetnage)
                )
            )
            i += 1
        }
        pieChartView.segments = labelledSegments
        pieChartView.segmentLabelFont = .systemFont(ofSize: 10)
        addSubview(pieChartView)
        pieChartView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        pieChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        pieChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        pieChartView.topAnchor.constraint(equalTo: titleLabelChart.bottomAnchor, constant: 16).isActive = true
        //pieChartView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pieChartView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        //self.generateGraph(with: question, with: colors)
    }
    */
    
    

}


class AvatarCell: BaseTableViewCell {
    
    let localStorage = UserDefaults.standard
    
    let sizeAvatarImageView: CGFloat = 80.0
    
    let avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFit
        avatar.image = UIImage(named: Constants.ImageName.avatar)
        avatar.layer.cornerRadius = 70/2
        avatar.clipsToBounds = true
        return avatar
    }()
    
    
    let containerAvatar: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        container.layer.cornerRadius = 80/2
        container.layer.masksToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: -1, height: 1)
        container.layer.shadowRadius = 5
        return container
    }()
    
    func setUpView() {
        selectionStyle = .none
        addSubview(containerAvatar)
        containerAvatar.isUserInteractionEnabled = true
        containerAvatar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerAvatar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerAvatar.widthAnchor.constraint(equalToConstant: sizeAvatarImageView).isActive = true
        containerAvatar.heightAnchor.constraint(equalToConstant: sizeAvatarImageView).isActive = true
        containerAvatar.addSubview(avatar)
        containerAvatar.addBorder(borderColor: .lightGray, widthBorder: 1)
        avatar.isUserInteractionEnabled = true
        avatar.centerXAnchor.constraint(equalTo: containerAvatar.centerXAnchor).isActive = true
        avatar.centerYAnchor.constraint(equalTo: containerAvatar.centerYAnchor).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        guard let urlString = UserDefaults.standard.string(forKey: "url-firestore"), !urlString.isEmpty, let url = URL(string: urlString) else {
            self.avatar.image = nil
            guard let avatarData = UserDefaults.standard.data(forKey: "avatar") else {
                return
            }
            
            let dataToView: UIImage = UIImage(data: avatarData)!
            self.avatar.image = dataToView
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                return
            }
            guard
                let httpURLResponse = response as? HTTPURLResponse, (200...299).contains(httpURLResponse.statusCode),
                let data = data, error == nil
            else { return }
            
            DispatchQueue.main.async {
                self.avatar.image = UIImage(data: data)
            }
            
        }
        task.resume()
        
        
    }
    
}



class UsernameCell: BaseTableViewCell {
    
    lazy var usernameTextField: UITextField = {
        let field = CustomTextField.getTextField(withPlaceholder: Constants.Strings.username)
        field.keyboardType = .alphabet
        field.tag = Constants.Tags.userNameInput
        return field
    }()
    
    func setUpView() {
        selectionStyle = .none
        addSubview(usernameTextField)
        usernameTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        usernameTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
}




class GraphCell: BaseTableViewCell {
    
    func setUpView() {
        selectionStyle = .none
        textLabel?.text = "Gráfica"
        textLabel?.textAlignment = .center
    }
    
}

