//
//  CardView.swift
//  TinderSwiftUI
//
//  Created by 富永開陽 on 2022/12/19.
//

import SwiftUI

struct CardView: View {
    
    @State var transration: CGSize = .zero
    @State var clearness: Double = 0
    
    var body: some View {
        
        ZStack {
            Image(systemName: "star")
                 .resizable()
                 .scaledToFit()
                 .background(.clear)
             
             LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
            
            VStack {
                HStack {
                    Text("GOOD")
                        .font(.system(size: 50, weight: .heavy))
                        .foregroundColor(.green)
                        .padding(4)
                        .opacity(clearness)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.green, lineWidth: 4)
                        )
                        .opacity(clearness)

                    
                    Spacer()
                    
                    Text("NOPE")
                        .font(.system(size: 50, weight: .heavy))
                        .foregroundColor(.red)
                        .padding(4)
                        .opacity(clearness)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.red, lineWidth: 4)
                        )
                        .opacity(clearness)

                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top)
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("kaiyo")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        Text("東京")
                        Text("バドミントン")
                        Text("バドミントン好き")
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                       Image(systemName: "info.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                    }
                    .buttonStyle(.plain)

                }
                .padding(.leading ,20)
                .padding(.trailing, 40)
                .padding(.bottom, 20)
            }
                
        }
        .frame(maxWidth: .infinity, maxHeight: 600)
        .shadow(radius: 20)
        .cornerRadius(10)
        .padding(.all, 10)
        .offset(transration)
        .rotationEffect(.degrees(Double(self.transration.width / 300 * 20)))
        .gesture(
            DragGesture()
                .onChanged({ value in
                    transration = value.translation
                    clearness = value.location.x / 200
                })
                .onEnded({ value in
                    
                    if value.location.x < value.startLocation.x - 150 {
                        self.transration = .init(width: -800, height: 0)
                    } else if value.location.x > value.startLocation.x + 150 {
                        self.transration = .init(width: 800, height: 0)
                    } else {
                        transration = .zero
                    }
                    
                    
                })
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 1))
        
       
            
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}






