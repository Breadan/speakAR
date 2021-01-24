//
//  SongTitle.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/18/21.
//

import SwiftUI

struct SongTitle: View {
    var songsQueue: (loadedSongURLs: [String], queueIndex: Int?)
    
    var body: some View {
        Button(action: {
            print("DEBUG: Song title pressed")
        }) {
            if let currentIndex = songsQueue.queueIndex {
                Text(songsQueue.loadedSongURLs[currentIndex])
                    .foregroundColor(Color.white)
            } else {
                Text("Not Playing")
                    .foregroundColor(Color.white)
            }
        }
    }
}
