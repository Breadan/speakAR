//
//  SongList.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/18/21.
//

import SwiftUI

private let iconSize: CGFloat = 15

struct Songlist: View {
    @Binding var isMusicControls: Bool
    @Binding var songs: [String:Song]
    @Binding var songsQueue: (loadedSongURLs: [String], queueIndex: Int?)
    
    //@State var loadedSongURLs: [String] = [] // later on, maybe have the individual SonglistRows contribute to this so that the SonglistRows can real-time identify if they're loaded
    @State var selectedSongURLs: [String] = []
    
    var body: some View {
        VStack {
            SongLoader(isMusicControls: $isMusicControls, songs: $songs, selectedSongURLs: $selectedSongURLs, songsQueue: $songsQueue)
            
            List {
                ForEach(Array(songs.values)) { song in
                    SonglistRow(song: song, selectedSongURLs: $selectedSongURLs)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.25))
    }
}


struct SonglistRow: View, Identifiable {
    let id = UUID()
    var song: Song
    
    @Binding var selectedSongURLs: [String]
    
    @State var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "music.note")
                .font(.system(size: iconSize))
                .foregroundColor(isSelected ? Color.blue : Color.blue)
            Text(song.songName)
                .onTapGesture() {
                    self.isSelected.toggle()
                    
                    if isSelected {
                        selectedSongURLs.append(self.song.songURL)
                    } else {
                        selectedSongURLs.remove(at: selectedSongURLs.firstIndex(of: self.song.songURL)!)
                    }
                    
                    print("\nDEBUG: Selected songs are \(selectedSongURLs)")
                }
            if song.songResource != nil {
                Spacer()
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: iconSize))
                    .foregroundColor(.green)
            }

        }
    }
}
