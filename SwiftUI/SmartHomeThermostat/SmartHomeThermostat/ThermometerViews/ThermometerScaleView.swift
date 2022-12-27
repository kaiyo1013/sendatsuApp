//
//  ThermometerScaleView.swift
//  SmartHomeThermostat
//
//  Created by 富永開陽 on 2022/10/29.
//

import SwiftUI

struct ThermometerScaleView: View {
    
    private let scaleSize: CGFloat = 276
    private let horisontalPadding: CGFloat = 20
    private let verticalpadding: CGFloat = 25
    
    var body: some View {
        ZStack {
            ForEach(0..<21) { line in
                scaleLine(at: line)
            }
            .frame(width: scaleSize, height: scaleSize)
            .rotationEffect(.degrees(270))
            
            HStack {
                Text("10°")
                Spacer()
                Text("30°")
            }
            
            VStack {
                Text("20°")
                Spacer()
            }
        }
        .frame(width: 390 - 2 * horisontalPadding, height: 390 - 2 * verticalpadding)
        .font(.subheadline)
        .foregroundColor(.white.opacity(0.3))
        
    }
    
    func scaleLine(at line: Int) -> some View {
        VStack {
            Rectangle()
                .fill(Color("Scale Line"))
                .frame(width: 2, height: 10)
            
            Spacer()
        }
        .rotationEffect(.degrees(Double(line) * 9))
    }
}

struct ThermometerScaleView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerScaleView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
