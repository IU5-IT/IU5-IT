//
//  NotConnectedView.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 21.09.2023.
//

import SwiftUI

struct NotConnectedView: View {
    var errorMessage: String?
    var handler: MKREmptyBlock?
    
    var body: some View {
        VStack(spacing: 20) {
            Image("not_found")
                .resizeImage(mode: .fit, width: 200, height: 200)
            
            if let msg = errorMessage {
                Text(msg)
                    .font(.footnote)
            }
            
            Button(action: {
                handler?()
            }, label: {
                Text("Повторить")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, design: .rounded))
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient.kingGradient.opacity(0.2))
                            .padding(.horizontal)
                    )
            })
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke()
                .fill(LinearGradient.kingGradient.opacity(0.5))
        )
    }
}

#Preview {
    NotConnectedView()
}
