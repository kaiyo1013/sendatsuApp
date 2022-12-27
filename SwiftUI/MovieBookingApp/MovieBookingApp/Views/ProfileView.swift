//
//  Profile.swift
//  MovieBookingApp
//
//  Created by 富永開陽 on 2022/10/05.
//

import SwiftUI

struct ProfileView: View {
    
    @State var animate = false
    
    @State var userName = ""
    @State var email = ""
    @State var favoriteMovie = ""

    
    var body: some View {
        ZStack (alignment: .top){
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
            
            VStack (spacing: 30){
                
                Text("Profile")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Spacer()
                    .frame(height: 20)
                
                
                ZStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .foregroundColor(.black)
                        .background(.white)
                        .cornerRadius(100)
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .frame(width: 60, height: 60)
                            .background(Color("lightPurple"))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .padding(EdgeInsets(top: -100, leading: 150, bottom: 0, trailing: 0))
                    })
                }
                
                Spacer()
                    .frame(height: 10)
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    
                    TextField("username", text: $userName)
                       
                }
                .padding(EdgeInsets(top: 7, leading: 8, bottom: 7, trailing: 8))
                .background(.ultraThickMaterial)
                .cornerRadius(10)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    
                    TextField("email", text: $email)
                       
                }
                .padding(EdgeInsets(top: 7, leading: 8, bottom: 7, trailing: 8))
                .background(.ultraThickMaterial)
                .cornerRadius(10)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    
                    TextField("Favorite Movie", text: $favoriteMovie)
                       
                }
                .padding(EdgeInsets(top: 7, leading: 8, bottom: 7, trailing: 8))
                .background(.ultraThickMaterial)
                .cornerRadius(10)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("darkPurple"), Color("dark")]), startPoint: .top, endPoint: .bottom))
    }
    
}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
