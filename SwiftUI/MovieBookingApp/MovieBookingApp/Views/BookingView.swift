//
//  BookingView.swift
//  MovieBookingApp
//
//  Created by 富永開陽 on 2022/10/06.
//

import SwiftUI

struct BookingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var backgroundColors = [Color("dark").opacity(0), Color("dark"), Color("dark"), Color("dark")]
    
    @State var image = "booking"
    
    @State var isSelected = false
    @State var bindingSelection = false
    @State var selectedHour = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity ,alignment: .top)
                
                VStack {
                    LinearGradient(colors: backgroundColors, startPoint: .top, endPoint: .bottom)
                        .frame(height: 600)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                
                VStack {
                    HStack(spacing: 0) {
                        CircleButton(action: {
                            dismiss()
                        }, image: "arrow.left")
                        
                        Spacer()
                        
                        CircleButton(action: {}, image: "ellipsis")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(EdgeInsets(top: 48, leading: 20, bottom: 0, trailing: 20))
                }
                
                VStack {
                    Text("Doctor Strange")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("in the Multiverse of Madness")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    Text("Dr. Stephen Strange casts a forbidden spells that opens the doorway to the multiverse, including altanative versions of... ")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(20)
                    
                    Text("Select Date and Time")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    HStack (alignment: .top, spacing: 20) {
                        DateButton(weekDay: "Thu", numDay: "21", isSelected: $bindingSelection)
                            .padding(.top, 90)
                        DateButton(weekDay: "Fri", numDay: "22", isSelected: $bindingSelection)
                            .padding(.top, 60)
                        DateButton(weekDay: "Sat", numDay: "23", width: 70, height: 100 ,isSelected: $isSelected, action: {
                            withAnimation(.spring()) {
                                isSelected.toggle()
                            }
                        })
                        .padding(.top, 20)
                        DateButton(weekDay: "Sun", numDay: "24", isSelected: $bindingSelection)
                            .padding(.top, 60)
                        DateButton(weekDay: "Mon", numDay: "25", isSelected: $bindingSelection)
                            .padding(.top, 90)
                    }
                    
                    HStack (alignment: .top, spacing: 20) {
                        TimeButton(hour: "16:00", isSelected: $bindingSelection)
                        TimeButton(hour: "17:00", isSelected: $bindingSelection)
                        TimeButton(hour: "18:00", width: 70 ,isSelected: $selectedHour, action: {
                            withAnimation(.spring()) {
                                selectedHour.toggle()
                            }
                        })
                        TimeButton(hour: "19:00", isSelected: $bindingSelection)
                        TimeButton(hour: "20:00", isSelected: $bindingSelection)
                    }
                    
                    NavigationLink {
                        SeatsView()
                    } label: {
                        LargeButton()
                            .padding(.top, 20)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .offset(y: isSelected && selectedHour ? 0 : 200)
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 300)
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("darkPurple"))
        .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView()
    }
}
