//
//  ScrollSection.swift
//  MovieBookingApp
//
//  Created by 富永開陽 on 2022/10/06.
//

import SwiftUI

struct ScrollSection: View {
    
    @State var posters: [String] = ["poster1", "poster2", "poster3", "poster4", "poster5", "poster6"]

    @State var title = "Now Playing"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    NavigationLink {
                        BookingView()
                    } label: {
                        ForEach(posters.indices, id: \.self) { index in
                            Image(posters[index])
                                .resizable()
                                .frame(width: 100, height: 130)
                                .cornerRadius(20)
                                .padding(.trailing, 10)
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
    }
}

struct ScrollSection_Previews: PreviewProvider {
    static var previews: some View {
        ScrollSection()
    }
}
