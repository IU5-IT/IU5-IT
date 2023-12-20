//
//  UIColor+Ext.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 13.09.2023.
//

import SwiftUI

extension LinearGradient {
    
    static let kingGradient = LinearGradient(
        colors: [.pink, .indigo, .cyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let instagramCircle = LinearGradient(
        colors: [
            Color(#colorLiteral(red: 1, green: 0, blue: 0.845524013, alpha: 1)),
            Color(#colorLiteral(red: 1, green: 0.4512313604, blue: 0.3125490546, alpha: 1)),
            Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        ],
        startPoint: .leading,
        endPoint: .bottom
    )

    static let white = LinearGradient(
        colors: [
            .white
        ],
        startPoint: .leading,
        endPoint: .bottom
    )
}
