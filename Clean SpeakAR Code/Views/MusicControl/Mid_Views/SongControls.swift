//
//  SongController.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/18/21.
//

import SwiftUI

struct SongControls: View {
    @Binding var songsQueue: (loadedSongURLs: [String], queueIndex: Int?)    // SongControls will generally deal with 'queueIndex' part of tuple
    @Binding var isPlaying: Bool
    
    var body: some View {
        HStack {
            // BACK BUTTON
            Button(action: {
                print("DEBUG: Songcontrols backward button pressed")
                if !songsQueue.loadedSongURLs.isEmpty {
                    if songsQueue.queueIndex != nil {
                        print("DEBUG: Current index \(songsQueue.queueIndex!)")
                        songsQueue.queueIndex! -= 1
                        // Negative bounds checker
                        if songsQueue.queueIndex! < 0 {
                            songsQueue.queueIndex = songsQueue.loadedSongURLs.count-1
                        }
                    } else {
                        // First time queueing song, set to 0
                        songsQueue.queueIndex = 0
                    }
                } else {
                    songsQueue.queueIndex = nil
                    print("DEBUG: No songs to traverse")
                }
                
            }) {
                Image(systemName: "backward.fill")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            }
            
            // PLAY BUTTON & PAUSE BUTTON
            if isPlaying {
                Button(action: {
                    print("DEBUG: Songcontrols pause button pressed")
                    isPlaying = false
                    
                }) {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            } else {
                Button(action: {
                    print("DEBUG: Songcontrols play button pressed")
                    isPlaying = true
                    
                }) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            
            // FORWARD BUTTON
            Button(action: {
                print("DEBUG: Songcontrols forward button selected")
                if !songsQueue.loadedSongURLs.isEmpty {
                    if songsQueue.queueIndex != nil {
                        print("DEBUG: Current index \(songsQueue.queueIndex!)")
                        print("DEBUG: Overlimit is \(songsQueue.loadedSongURLs.count-1)")
                        songsQueue.queueIndex! += 1
                        // Over bounds checker
                        if songsQueue.queueIndex! > songsQueue.loadedSongURLs.count-1 {
                            songsQueue.queueIndex = 0
                        }
                    } else {
                        // First time queueing song, set to 0
                        songsQueue.queueIndex = 0
                    }
                } else {
                    songsQueue.queueIndex = nil
                    print("DEBUG: No songs to traverse")
                }
                
            }) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
