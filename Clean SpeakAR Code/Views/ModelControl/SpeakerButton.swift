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
        Button(action: {
            isSpeakerSelected = true
            print("DEBUG: Speaker button pressed")
        }) {
            Image(systemName: "hammer.fill")
                .resizable()
                    .frame(width: 75, height: 75)
                    .aspectRatio(1/1, contentMode: .fit)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 7)
        }
    }
}
