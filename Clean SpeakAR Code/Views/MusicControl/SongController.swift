//
//  SongController.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/18/21.
//

import SwiftUI

struct SongController: View {
    var body: some View {
        HStack {
            Button(action: {
                print("DEBUG: back button selected")
            }) {
                Text("Back button")
            }
            
            Button(action: {
                print("DEBUG: play/button button selected")
            }) {
                Text("Play/Pause button")
            }
            
            Button(action: {
                print("DEBUG: next button selected")
            }) {
                Text("Next button")
            }
        }
    }
}
