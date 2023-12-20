//
//  AuthorCircle.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 17.09.2023.
//

import SwiftUI

struct AuthorCircle: View {
    var username: String = .username
    var isActive: Bool = true
    
    var imageConfiguration: MKRImageView.Configuration = .imageConfiguration
    
    var body: some View {
        VStack{
            MKRImageView(configuration: imageConfiguration)
            .authorBorders(isActive: isActive)
            
            Text(username.lowercased())
                .font(.caption)
                .foregroundColor(Color.primary)
                .frame(maxWidth: .widthTitle)
                .lineLimit(.maxLines)
        }
    }
}

// MARK: - Extension View

private extension View {
    
    func authorBorders(isActive: Bool) -> some View {
        return self
            .padding(.borderPadding)
            .overlay {
                Circle()
                    .stroke(lineWidth: .borderLineWidth)
                    .fill(
                        isActive
                        ? LinearGradient.instagramCircle
                        : LinearGradient(
                            colors: [Color.gray.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .top
                        )
                    )
            }
    }
}

// MARK: - Image Configuration

private extension MKRImageView.Configuration {
    
    static var imageConfiguration: Self = .basic(
        kind: .custom(
            url: .mockLoadingUrl,
            mode: .fill,
            imageSize: .imageSize,
            imageCornerRadius: .imageCornerRadius,
            imageBorderWidth: .zero,
            imageBorderColor: nil,
            placeholderLineWidth: .zero
        )
    )
}

// MARK: - Contants

private extension Int {
    
    static let maxLines = 1
}

private extension CGSize {
    
    static let imageSize = CGSize(edge: 82)
}

private extension CGFloat {

    static let imageCornerRadius: CGFloat = 41
    static let widthTitle: CGFloat = 90
    static let borderLineWidth: CGFloat = 3
    /// Padding between image and circle
    static let borderPadding: CGFloat = 3
}

private extension String {
    
    static let username = "mightyK1ngRichard"
}

// MARK: - Preview

struct AuthorCircle_Previews: PreviewProvider {
    static var previews: some View {
        AuthorCircle()
    }
}
