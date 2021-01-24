//
//  MusicControlsView.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/17/21.
//

import SwiftUI
import RealityKit

struct MusicControlsView: View {
    @Binding var audioController: AudioPlaybackController?
    @Binding var isMusicControls: Bool
    @Binding var songs: [String:Song]
    @Binding var songsQueue: (loadedSongURLs: [String], queueIndex: Int?)
    @Binding var isTraversed: Bool
    @Binding var isPlaying: Bool
    
    var body: some View {
        ZStack {
              VStack {
                  HStack {
                    SongSearchBar(text: .constant(""))
                    Spacer()
                    MusicControlsButton(isMusicControls: $isMusicControls)
                  }
                  .padding(.top, 45)
                  .padding(.horizontal, 25)
                  .padding(.bottom, 25)
                  
                  HStack {
                      CurrentSongThumbnail()
                        .cornerRadius(8)
                      
                      Spacer()
                          VStack {
                            Spacer()
                            SongTitle(songsQueue: songsQueue)
                            ProgressBar(songsQueue: songsQueue)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                            
                            SongControls(songsQueue: $songsQueue, isTraversed: $isTraversed, isPlaying: $isPlaying)
                            
                            Spacer()

                          }
                          .background(Color.black.opacity(0.50))
                          .frame(width: 171.6, height:171.6)
                          .cornerRadius(8)

                  }
                  .padding(.bottom, 25)
                  .padding(.horizontal, 25)
                
             
                Songlist(audioController: $audioController, isMusicControls: $isMusicControls, songs: $songs, songsQueue: $songsQueue, isPlaying: $isPlaying)
                
                
                .padding(.horizontal, 25)
                .padding(.bottom, 45)
                .cornerRadius(8)
                  
              }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
    
}


