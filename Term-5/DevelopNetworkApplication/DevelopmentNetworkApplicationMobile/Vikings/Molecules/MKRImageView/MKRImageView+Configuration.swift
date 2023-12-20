//
//  MKRImageView+Configuration.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 17.09.2023.
//

import SwiftUI

extension MKRImageView {
    
    struct Configuration: ConfigurationRequirements {
        var url                  : URL? = nil
        var mode                 : ContentMode = .fill
        var imageSize            : CGSize = .zero
        var imageCornerRadius    : CGFloat = .zero
        var imageBorderWidth     : CGFloat = .zero
        var imageBorderColor     : Color? = nil
        var placeholderLineWidth : CGFloat = .zero
        var placeholderImageSize : CGFloat = .zero
    }
}

// MARK: - Kind

extension MKRImageView.Configuration {
    
    /// Kind of image configuration
    enum Kind {
        case clear
        case preview
        case custom(
            url                  : URL? = nil,
            mode                 : ContentMode = .fill,
            imageSize            : CGSize = .zero,
            imageCornerRadius    : CGFloat = .zero,
            imageBorderWidth     : CGFloat = .zero,
            imageBorderColor     : Color? = nil,
            placeholderLineWidth : CGFloat = .zero,
            placeholderImageSize : CGFloat = .zero
        )
    }
    
    /// Empty View
    static var clear: Self {
        .init()
    }
}
