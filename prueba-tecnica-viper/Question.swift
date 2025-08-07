//
//  Question.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation

struct Question: Decodable {
    let pregunta: String
    let values: [ChartValue]
}
