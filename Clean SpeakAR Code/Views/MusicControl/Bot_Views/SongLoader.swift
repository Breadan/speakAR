//
//  SongLoader.swift
//  Clean SpeakAR Code
//
//  Created by Brendan Yang on 1/21/21.
//

import SwiftUI

struct SongLoader: View {
    @Binding var isMusicControls: Bool
    @Binding var songs: [String:Song]
    @Binding var selectedSongURLs: [String]
    @Binding var songsQueue: (loadedSongURLs: [String], queueIndex: Int?) // SongLoader will generally deal with the 'loadedSongs' part of tuple
    
    var body: some View {
        HStack {
            Button(action: {
                print("DEBUG: Load all songs button pressed")
                initializeSongs(from: songs)
                songsQueue.loadedSongURLs = Array(songs.keys)    // Queue all song URLs
                isMusicControls = false
            }) {
                Image(systemName: "rectangle.stack.fill.badge.plus")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
                    .padding(5)
                    .padding(.leading, 50)
            }
            
            Button(action: {
                print("DEBUG: Unload all songs button pressed")
                deinitializeSongs(from: songs)
                songsQueue.loadedSongURLs = []                  // Emtpy song queue
                songsQueue.queueIndex = nil                     // Set index to no queue (allowed here since we know for sure no songs loaded)
                isMusicControls = false
            }) {
                Image(systemName: "rectangle.stack.badge.minus")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
                    .padding(5)
            }
            
            Button(action: {
                print("DEBUG: Load selected songs button pressed")
                initializeSongs(of: selectedSongURLs, from: songs, all: false)
                songsQueue.loadedSongURLs += selectedSongURLs.filter { !songsQueue.loadedSongURLs.contains($0) }    // Queue only loaded song URLs from selectedURLs that loadedSongURLs does not already contain (aka add selected songs)
                print("DEBUG: Check load selected songs \(songsQueue.loadedSongURLs)")
                isMusicControls = false
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
                    .padding(5)
            }
            
            Button(action: {
                print("DEBUG: Unload selected songs button pressed")
                deinitializeSongs(of: selectedSongURLs, from: songs, all: false)
                songsQueue.loadedSongURLs = songsQueue.loadedSongURLs.filter { !selectedSongURLs.contains($0) }    // Filter (keep) only songs that selectedSongURLs does not contain
                songsQueue.queueIndex = nil
                isMusicControls = false
            }) {
                Image(systemName: "minus.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
                    .padding(5)
            }
            
            Spacer()
            
            Button(action: {
                print("DEBUG: Refresh songs button pressed")
                isMusicControls = false
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
                    .padding(5)
            }
            Spacer()
        }
    
    }
    
}
