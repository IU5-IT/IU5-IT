//
//  Optional+Ext.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 19.09.2023.
//

import Foundation

extension Optional where Wrapped == String {
    
    var toURL: URL? {
        guard let self else { return nil }
        return URL(string: self)
    }
}
