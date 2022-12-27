//
//  TicketView.swift
//  MovieBookingApp
//
//  Created by 富永開陽 on 2022/10/02.
//

import SwiftUI

struct TicketView: View {
    
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
            VStack(spacing: 30) {
                Text("Mobile Ticket")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("Once you buy a movie ticket, simply scan the barcode to access to your movie")
                    .font(.body)
                    .foregroundColor(.white)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 248)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            Tickets()
                .padding(.top, 20)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("darkPurple"), Color("dark")]), startPoint: .top, endPoint: .bottom))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView()
    }
}
