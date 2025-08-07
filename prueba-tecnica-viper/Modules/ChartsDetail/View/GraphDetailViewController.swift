//
//  GraphDetailViewController.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import UIKit
import SwiftUI


class GraphDetailViewController: UIViewController, ChartsDetailViewProtocol {
    
    var presenter: ChartsDetailPresenterProtocol?
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30 // Espacio entre las gráficas
        return stackView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mercury
        setupViews()
        // Notifica al Presenter que la vista está lista para recibir datos.
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Setup
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func displayCharts(with questions: [Question]) {
        DispatchQueue.main.async {
            for view in self.stackView.arrangedSubviews {
                view.removeFromSuperview()
            }
            
            for question in questions {
                let chartView = PieChartView(question: question)
                let hostingController = UIHostingController(rootView: chartView)
                
                self.addChild(hostingController)
                self.stackView.addArrangedSubview(hostingController.view)
                hostingController.didMove(toParent: self)
                
                // Altura a la vista de la gráfica.
                //hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                //hostingController.view.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
            }
        }
    }
    
    func displayError(message: String) {
        DispatchQueue.main.async {
            Alert.show(title: "Error", message: message, on: self)
        }
    }
    
}

/*
class GraphDetailViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        loadChartData()
    }

    private func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func loadChartData() {
        guard let url = Bundle.main.url(forResource: "test", withExtension: "json") else {
            print("No se pudo encontrar el archivo test.json")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let chartData = try JSONDecoder().decode(ChartData.self, from: data)
            displayCharts(for: chartData.data)
        } catch {
            print("Error al cargar o decodificar el JSON: \(error)")
        }
    }

    private func displayCharts(for questions: [Question]) {
        for question in questions {
            let chartView = PieChartView(question: question)
            let hostingController = UIHostingController(rootView: chartView)
            addChild(hostingController)
            stackView.addArrangedSubview(hostingController.view)
            hostingController.didMove(toParent: self)
        }
    }
}
*/
