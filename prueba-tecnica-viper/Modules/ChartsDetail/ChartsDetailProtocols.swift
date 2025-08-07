//
//  ChartsDetailProtocols.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit


// --- Protocolo de la Vista ---
// La Vista debe implementar este protocolo para que el Presenter pueda enviarle datos.
protocol ChartsDetailViewProtocol: AnyObject {
    var presenter: ChartsDetailPresenterProtocol? { get set }
    
    // El Presenter llamará a esta función para pasarle los datos de las gráficas.
    func displayCharts(with questions: [Question])
    // El Presenter llamará a esto si ocurre un error al cargar los datos.
    func displayError(message: String)
}


// --- Protocolo del Presenter ---
protocol ChartsDetailPresenterProtocol: AnyObject {
    var view: ChartsDetailViewProtocol? { get set }
    var interactor: ChartsDetailInteractorInputProtocol? { get set }
    var router: ChartsDetailRouterProtocol? { get set }
    
    // La Vista llamará a esto cuando haya cargado.
    func viewDidLoad()
}

// El Interactor usa este protocolo para comunicarse de vuelta con el Presenter.
protocol ChartsDetailInteractorOutputProtocol: AnyObject {
    func didRetrieveChartData(_ questions: [Question])
    func didFailToRetrieveChartData(error: Error)
}


// --- Protocolo del Interactor ---
// El Presenter usa este protocolo para pedirle datos al Interactor.
protocol ChartsDetailInteractorInputProtocol: AnyObject {
    var presenter: ChartsDetailInteractorOutputProtocol? { get set }
    
    func fetchChartData()
}


// --- Protocolo del Router ---
// El Router implementa esto para poder construir el módulo.
protocol ChartsDetailRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

