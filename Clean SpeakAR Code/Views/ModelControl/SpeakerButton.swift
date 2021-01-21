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
    
    // put this in content view, to the V stack later       .padding(.bottom, 50)

    
    var body: some View {
//        VStack {
            Button(action: {
                isSpeakerSelected = true
                print("DEBUG: Speaker button pressed")
            }) {
                    Image("Apple Homepod")
                    .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(1/1, contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
            }
//        }
//        .padding(.bottom, 50)
    }
}
