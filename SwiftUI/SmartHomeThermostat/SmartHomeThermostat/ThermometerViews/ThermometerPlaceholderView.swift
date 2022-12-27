//
//  ThermometerPlaceholderView.swift
//  SmartHomeThermostat
//
//  Created by 富永開陽 on 2022/10/27.
//

import SwiftUI

struct ThermometerPlaceholderView: View {
    
    private let placeholderSize: CGFloat = 244
    
    let colors = [Color("Placeholder 1"), Color("Placeholder 2")]
    
    var body: some View {
        Circle()
            .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: placeholderSize, height: placeholderSize)
            .shadow(color: Color("Placeholder Drop Shadow") ,radius: 30, x: 0, y: 15)
            .overlay {
                // placeholder border
                Circle()
                    .stroke(LinearGradient(colors: [.black.opacity(0.36), .white.opacity(0.11)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
            }
        
            .overlay {
                // placeholder inner shadow
                Circle()
                    .stroke(Color("Placeholder Inner Shadow"), lineWidth: 2)
                    .blur(radius: 7)
                    .offset(x: 0, y: 3)
                    .mask {
                        Circle()
                            .fill(LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
                    }
            }
    }
}

struct ThermometerPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerPlaceholderView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
