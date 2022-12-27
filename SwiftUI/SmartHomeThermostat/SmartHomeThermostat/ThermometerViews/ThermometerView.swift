//
//  ThermometerView.swift
//  SmartHomeThermostat
//
//  Created by 富永開陽 on 2022/10/27.
//

import SwiftUI

enum Status: String {
    case heating = "HEATING"
    case cooling = "COOLING"
    case reaching = "REACHING"
}

struct ThermometerView: View {
    private let ringSize: CGFloat = 220
    private let minTemp: CGFloat = 4
    private let maxTemp: CGFloat = 30
    
    @State private var currentTemperature: CGFloat = 0
    @State private var degrees: CGFloat = 36
    
    var ringValue: CGFloat {
        return currentTemperature / 40
    }
    
    var targetTemperature: CGFloat {
        return min(max(degrees / 360 * 40, minTemp), maxTemp)
    }
    
    var status: Status {
        if currentTemperature < targetTemperature {
            return .heating
        } else if currentTemperature > targetTemperature {
            return .cooling
        } else {
            return .reaching
        }
    }
    
    
    var body: some View {
        ZStack {
            
            ThermometerScaleView()
            
            ThermometerPlaceholderView()
            
            Circle()
                .inset(by: 5)
                .trim(from: 0.099, to: min(ringValue, 0.75))
                .stroke(LinearGradient(colors: [Color("Temperature Ring 1"), Color("Temperature Ring 2")], startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .frame(width: ringSize, height: ringSize)
                .rotationEffect(.degrees(90))
                .animation(.linear(duration: 1), value: ringValue)
            
            ThermometerDialView(degrees: degrees)
                .gesture {
                    DragGesture()
                        .onChanged({ value in
                            let x = min(max(value.location.x, 0), 200)
                            let y = min(max(value.location.y, 0), 200)
                            
                            let endPoint = CGPoint(x: x, y: y)
                            let centerPoint = CGPoint(x: 200 / 2, y: 200 / 2)
                            
                            let angle = calculateAngle(centerPoint: centerPoint, endPoint: endPoint)
                            
                            degrees = angle
                        })
                }
            
            ThermometerSummaryView(status: status, showStatus: true, temperature: 22)
        }
        
        .onAppear {
            currentTemperature = 22
            degrees = currentTemperature / 40 * 360
        }
    }
}

struct ThermometerView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
