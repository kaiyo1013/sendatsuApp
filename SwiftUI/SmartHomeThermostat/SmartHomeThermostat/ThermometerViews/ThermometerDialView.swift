//
//  ThermometerDialView.swift
//  SmartHomeThermostat
//
//  Created by 富永開陽 on 2022/10/27.
//

import SwiftUI

struct ThermometerDialView: View {
    
    private let outerDialSize: CGFloat = 200
    private let innerDialSize: CGFloat = 172
    private let setPointSize: CGFloat = 15
    var degrees: CGFloat = 0

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [Color("Outer Dial 1"), Color("Outer Dial 2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: outerDialSize, height: outerDialSize)
                .shadow(color: .black.opacity(0.2), radius: 60, x: 0, y: 30)
                .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
                .overlay {
                    Circle()
                        .stroke(LinearGradient(colors: [.white.opacity(0.2), .black.opacity(0.19)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                }
                .overlay {
                    Circle()
                        .stroke(.white.opacity(0.1), lineWidth: 4)
                        .blur(radius: 8)
                        .offset(x: 3, y: 3)
                        .mask {
                            Circle()
                                .fill(LinearGradient(colors: [.black, .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                        }
                }
            
            Circle()
                .fill(LinearGradient(colors: [Color("Inner Dial 1"), Color("Inner Dial 2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: innerDialSize, height: innerDialSize)
            
            Circle()
                .fill(LinearGradient(colors: [Color("Temperature Setpoint 1"), Color("Temperature Setpoint 2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: setPointSize, height: setPointSize)
                .frame(width: innerDialSize, height: innerDialSize, alignment: .top)
                .offset(x: 0, y: 7.5)
                .rotationEffect(.degrees(degrees + 180))
                .animation(.easeInOut(duration: 1), value: degrees)
        }
    }
}

struct ThermometerDialView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerDialView()
    }
}
