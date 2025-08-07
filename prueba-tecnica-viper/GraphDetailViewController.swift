//
//  GraphDetailViewController.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import UIKit
import SwiftUI

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
