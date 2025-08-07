//
//  PieChartView.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import SwiftUI
import Charts

struct PieChartView: View {
    let question: Question
    var body: some View {
        VStack {
            Text(question.pregunta)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            Chart(question.values) { dataPoint in
                SectorMark(
                    angle: .value("Value", dataPoint.value),
                    innerRadius: .ratio(0.5),
                    angularInset: 2.0
                )
                .foregroundStyle(by: .value("Label", dataPoint.label))
                .annotation(position: .overlay) {
                    Text("\(dataPoint.value)%")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .chartLegend(position: .bottom, alignment: .center, spacing: 10)
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }
    }
}

/*
#Preview {
    PieChartView()
}
*/
