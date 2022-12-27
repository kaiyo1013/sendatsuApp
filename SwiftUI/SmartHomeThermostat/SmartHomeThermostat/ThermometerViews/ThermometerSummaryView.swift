//
//  ThermometerSummaryView.swift
//  SmartHomeThermostat
//
//  Created by 富永開陽 on 2022/10/29.
//

import SwiftUI

struct ThermometerSummaryView: View {
    
    var status: Status
    var showStatus: Bool
    var temperature: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Text(status.rawValue)
                .font(.headline)
                .foregroundColor(.white)
                .opacity(showStatus ? 0.6 : 0)
                .animation(.easeIn(duration: 0.5), value: showStatus)
            
            Text("\(temperature, specifier: "%.0f")")
                .font(.system(size: 54))
                .foregroundColor(.white)
            
            Image(systemName: "leaf.fill")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
        }
        .padding(.top, 40)
    }
}

struct ThermometerSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerSummaryView(status: .heating, showStatus: true, temperature: 22)
            .background(Color("Inner Dial 2"))
    }
}
