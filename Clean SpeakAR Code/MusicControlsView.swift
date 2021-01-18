//
//  MusicControlsView.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/17/21.
//

import SwiftUI

struct MusicControlsView: View {
    @Binding var isMusicControls: Bool
    
    var body: some View {
        //here's another iteration of MusicControlsButton...
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        print("selected song search bar")
                    }) {
                        Text("Search for songs...")
                    }
                    
                    Spacer()
                    MusicControlsButton(isMusicControls: $isMusicControls)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .opacity(1)
    }
}
