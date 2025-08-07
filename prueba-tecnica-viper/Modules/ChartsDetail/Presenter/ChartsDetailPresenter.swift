//
//  ChartsDetailPresenter.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation

class ChartsDetailPresenter: ChartsDetailPresenterProtocol, ChartsDetailInteractorOutputProtocol {
    
    weak var view: ChartsDetailViewProtocol?
    var interactor: ChartsDetailInteractorInputProtocol?
    var router: ChartsDetailRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchChartData()
    }
    
    func didRetrieveChartData(_ questions: [Question]) {
        view?.displayCharts(with: questions)
    }
    
    func didFailToRetrieveChartData(error: Error) {
        view?.displayError(message: "No se pudieron cargar los datos de las gráficas: \(error.localizedDescription)")
    }
    
}

