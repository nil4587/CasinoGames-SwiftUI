//
//  PopupView.swift
//  SwiftUIGame
//
//  Created by Nileshkumar M. Prajapati on 2023/04/20.
//

import SwiftUI

struct PopupView: View {
    
    @Binding var isGameOver: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text("GAME OVER")
                .font(.system(.title, design: .rounded))
                .fontWeight(.heavy)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color("ColorPink"))
                .foregroundColor(.white)
            
            Spacer()
            
            //Message
            VStack(alignment: .center, spacing: 16) {
                Image("gfx-seven-reel")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 72)
                
                Text("Bad luck! You lost all your coins. \nLet's play again")
                    .font(.system(.body, design: .rounded))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .layoutPriority(1)
                
                Button {
                    isGameOver = false
                } label: {
                    Text("New Game".uppercased())
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.bold)
                        .tint(Color("ColorPink"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(width: 128)
                        .background(
                            Capsule()
                                .strokeBorder(lineWidth: 1.75)
                                .foregroundColor(Color("ColorPink"))
                        )
                }
            }
            Spacer()
        }
        .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isGameOver: Bool = false
        PopupView(isGameOver: $isGameOver)
            .previewLayout(.sizeThatFits)
    }
}
