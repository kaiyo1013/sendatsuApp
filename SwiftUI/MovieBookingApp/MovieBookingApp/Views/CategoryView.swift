//
//  Category.swift
//  MovieBookingApp
//
//  Created by 富永開陽 on 2022/10/05.
//

import SwiftUI

struct CategoryView: View {
    
    @State var animate = false
    
    var body: some View {
        ZStack {
            CircleBackground(color: Color("cyan"))
                .blur(radius: animate ? 80 : 150)
                .offset(x: animate ? -50 : -130, y: animate ? -30 : -100)
            
            CircleBackground(color: Color("pink"))
                .blur(radius: animate ? 80 : 150)
                .offset(x: animate ? 100 : 130, y: animate ? 150 : 100)
                .task {
                    withAnimation(.easeInOut(duration: 7).repeatForever()) {
                        animate.toggle()
                    }
                }
            
            VStack {
                Text("Category")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("darkPurple"), Color("dark")]), startPoint: .top, endPoint: .bottom))
    }
}


struct Category_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
