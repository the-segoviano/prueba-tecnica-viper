//
//  ChartsDetailRouter.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit

class ChartsDetailRouter: ChartsDetailRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = GraphDetailViewController()
        
        let presenter: ChartsDetailPresenterProtocol & ChartsDetailInteractorOutputProtocol = ChartsDetailPresenter()
        let interactor: ChartsDetailInteractorInputProtocol = ChartsDetailInteractor()
        let router: ChartsDetailRouterProtocol = ChartsDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    
}

