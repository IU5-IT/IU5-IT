//
//  String+Ext.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 18.09.2023.
//

import Foundation

extension String {
    
    var toURL: URL? {
        URL(string: self)
    }
}
