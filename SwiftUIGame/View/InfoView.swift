//
//  InfoView.swift
//  SwiftUIGame
//
//  Created by Nileshkumar M. Prajapati on 2023/04/20.
//

import SwiftUI

struct InfoView: View {
    
    //MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    
    //MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section(header: Text("About the application")) {
                    FormRowView(keyTitle: "Category", keyValue: "Casino Game")
                    FormRowView(keyTitle: "Platforms", keyValue: "iPhone, iPad, Mac")
                    FormRowView(keyTitle: "Developer", keyValue: "iOS Developer")
                    FormRowView(keyTitle: "Copyright", keyValue: "© 2023 All rights reserved.")
                    FormRowView(keyTitle: "Version", keyValue: "1.0.0")
                }
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top, 40)
        .overlay(
            Button(action: {
                //Action
                dismiss()
                audioPlayer?.stop()
            }, label: {
                Image(systemName: "xmark.circle")
            })
            .font(.title2)
            .padding(.top, 20)
            .padding(.trailing, 20)
            .tint(.white)
            , alignment: .topTrailing
        )
        .onAppear {
            playSound(sound: "background-music", type: "mp3")
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .bottomTrailing, endPoint: .topLeading))
    }
}



struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
