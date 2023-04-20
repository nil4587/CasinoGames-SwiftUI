//
//  FormRowView.swift
//  SwiftUIGame
//
//  Created by Nileshkumar M. Prajapati on 2023/04/20.
//

import SwiftUI

struct FormRowView: View {
    
    var keyTitle: String
    var keyValue: String
    
    var body: some View {
        HStack {
            Text(keyTitle)
                .foregroundColor(.gray)
            Spacer()
            Text(keyValue)
        }
        .padding(0)
    }
}

struct FormRowView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowView(keyTitle: "Application", keyValue: "Slot Machine")
            .previewLayout(.sizeThatFits)
    }
}
