//
//  PlacementButton.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/16/21.
//

import SwiftUI

struct PlacementButton: View {
    @Binding var isSpeakerSelected: Bool
    @Binding var isSpeakerPlaced: Bool
    
    var body: some View {
        HStack {
            // Cancel button
            Button(action: {
                print("DEBUG: Speaker placement cancelled")
                isSpeakerSelected = false
            }) {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            //confirm button
            Button(action: {
                print("DEBUG: Speaker placement confirmed")
                isSpeakerSelected = false
                isSpeakerPlaced = true
            }) {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
}
