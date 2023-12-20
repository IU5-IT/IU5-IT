//
//  CoffeeModel.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import Foundation

struct CoffeeModel: Identifiable {
    let id = UUID()
    var imageName: String
    var title: String
    var price: String
}
