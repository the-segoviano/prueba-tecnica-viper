//
//  ChartValue.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation

struct ChartValue: Decodable, Identifiable {
    var id = UUID()
    let label: String
    let value: Int
    
    private enum CodingKeys: String, CodingKey {
        case label, value
    }
}
