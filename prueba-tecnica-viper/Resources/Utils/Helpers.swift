//
//  Helpers.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit


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


class GraphCell: BaseTableViewCell {
    
    func setUpView() {
        selectionStyle = .none
        textLabel?.text = "Gráfica"
        textLabel?.textAlignment = .center
    }
    
}

