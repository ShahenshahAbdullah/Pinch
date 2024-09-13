//
//  ControllImageView.swift
//  Pinch
//
//  Created by Murad on 9/6/24.
//

import SwiftUI

struct ControllImageView: View {
    let icon : String
    var body: some View {
      
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

#Preview {
    ControllImageView(icon: "minus.magnifyingglass")
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
        .padding()
}
