//
//  MRKImageView+Defaults.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 17.09.2023.
//

import SwiftUI

extension MKRImageView.Configuration {
    
    /// Configuration of MKRImageView
    /// - Parameter kind: kind of configuration
    /// - Returns: configuration of MKRImageView
    static func basic(kind: Kind) -> Self {
        switch kind {
        case .preview:
            return .init(
                url: .mockLoadingUrl,
                mode: .imageMode,
                imageSize: .imageSize,
                imageCornerRadius: .imageCornerRadius,
                imageBorderWidth: .imageBorderWidth,
                imageBorderColor: .imageBorderColor,
                placeholderLineWidth: .placeholderLineWidth,
                placeholderImageSize: .placeholderImageSize
            )
        case let .custom(
            url,
            mode,
            imageSize,
            imageCornerRadius,
            imageBorderWidth,
            imageBorderColor,
            placeholderLineWidth,
            placeholderImageSize
        ): return .init(
            url: url,
            mode: mode,
            imageSize: imageSize,
            imageCornerRadius: imageCornerRadius,
            imageBorderWidth: imageBorderWidth,
            imageBorderColor: imageBorderColor,
            placeholderLineWidth: placeholderLineWidth,
            placeholderImageSize: placeholderImageSize
        )
        case .clear:
            return .init()
        }
    }
}

// MARK: - Constants

private extension Color {
    
    static let imageBorderColor: Color = .pink
}

private extension CGSize {
    
    static let imageSize = CGSize(width: 300, height: 200)
}

private extension CGFloat {
    
    static let imageCornerRadius: CGFloat = 20
    static let placeholderLineWidth: CGFloat = 2
    static let imageBorderWidth: CGFloat = 2
    static let placeholderImageSize: CGFloat = 30
}


private extension ContentMode {
    
    static let imageMode: Self = .fill
}
