//
//  ViewController+UITableView.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit


// MARK: - Delegate & Datasource UITableView

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
            let detalle: UIViewController = GraphDetailViewController()
            let nav = UINavigationController(rootViewController: detalle)
            detalle.modalPresentationStyle = .currentContext
            detalle.modalTransitionStyle = .coverVertical
            self.present(nav, animated: true, completion: nil)
            
            //self.navigationController?.pushViewController(nav, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch CustomSections.getSection(indexPath.row) {
        case .avatar:
            return 100.0
        case .userName:
            return 50.0
        case .graph:
            return 50.0
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
