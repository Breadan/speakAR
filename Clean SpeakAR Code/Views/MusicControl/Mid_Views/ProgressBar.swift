//
//  ProgressBar.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/18/21.
//

import SwiftUI

struct ProgressBar: View {
    var songsQueue: (loadedSongURLs: [String], queueIndex: Int?)
    
    var body: some View {
        
        // Hmm... how tf am I going to get the song duration??
        
        ZStack(alignment: .leading) {
           Rectangle()
              .foregroundColor(Color.gray)
              .opacity(0.3)
              .frame(height: 4.0)
           Rectangle()
              .foregroundColor(Color.blue)
            .frame(width: 30, height: 4.0)
        }
        .cornerRadius(4.0)
        .onTapGesture {
            print("DEBUG: selected progress bar")
        }
    }
}
