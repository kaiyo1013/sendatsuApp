//
//  TopView.swift
//  TinderSwiftUI
//
//  Created by 富永開陽 on 2022/12/19.
//

import SwiftUI

struct TopView: View {
    
    enum selectedButton {
        case tinder, good, comment, profile
    }

    @State var buttton: selectedButton = .tinder
    
    var body: some View {
        HStack (spacing: 70){
            Button {
                buttton = .tinder
            } label: {
                Image(systemName: "flame.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.plain)
            .frame(width: 30, height: 30)
            .foregroundColor(buttton == .tinder ? .red : .gray)
            Button {
                buttton = .good
            } label: {
                Image(systemName: "suit.diamond.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.plain)
            .frame(width: 30, height: 30)
            .foregroundColor(buttton == .good ? .yellow : .gray)
            Button {
                buttton = .comment
            } label: {
                Image(systemName: "bubble.left.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.plain)
            .frame(width: 30, height: 30)
            .foregroundColor(buttton == .comment ? .orange : .gray)
            Button {
                buttton = .profile
            } label: {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.plain)
            .frame(width: 30, height: 30)
            .foregroundColor(buttton == .profile ? .green : .gray)
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
    }
}

