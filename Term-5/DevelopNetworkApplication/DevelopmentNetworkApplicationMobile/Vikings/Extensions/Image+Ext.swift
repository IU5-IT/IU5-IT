//
//  Image+Ext.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 13.09.2023.
//

import SwiftUI

extension Image {
    
    func resizeImage(
        mode: ContentMode,
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: mode)
            .frame(width: width, height: height)
    }
}
