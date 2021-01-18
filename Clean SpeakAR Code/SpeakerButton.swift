//
//  SpeakerView.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/16/21.
//

import SwiftUI

struct SpeakerButton: View {
    @Binding var isSpeakerSelected: Bool
    @Binding var isSpeakerPlaced: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {print("speaker button pressed")
                isSpeakerSelected = true
                print("DEBUG: speaker has been selected")
            }) {
                    Image("Apple Homepod")
                    .resizable()
                    .frame(height: 100)
                    .aspectRatio(1/1, contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
            }
        }
        .padding(.bottom, 50)
    }
}
