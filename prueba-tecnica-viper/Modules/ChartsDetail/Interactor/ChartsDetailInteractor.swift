//
//  ChartsDetailInteractor.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation

class ChartsDetailInteractor: ChartsDetailInteractorInputProtocol {
    
    weak var presenter: ChartsDetailInteractorOutputProtocol?
    
    func fetchChartData() {
        
        guard let url = Bundle.main.url(forResource: "test", withExtension: "json") else {
            let error = NSError(domain: "com.viper.charts", code: 404, userInfo: [NSLocalizedDescriptionKey: "No se pudo encontrar el archivo test.json"])
            presenter?.didFailToRetrieveChartData(error: error)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let chartData = try JSONDecoder().decode(ChartData.self, from: data)
            presenter?.didRetrieveChartData(chartData.data)
        } catch {
            presenter?.didFailToRetrieveChartData(error: error)
        }
    }
    
}
