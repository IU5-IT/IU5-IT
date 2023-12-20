//
//  CGSize+Ext.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 17.09.2023.
//

import Foundation

extension CGSize {
    
    init(edge size: CGFloat) {
        self.init(width: size, height: size)
    }
}
