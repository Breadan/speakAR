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
//        ZStack {
                VStack {
                    HStack {
                        SongSearchBar()
                        MusicControlsButton(isMusicControls: $isMusicControls)
                    }
                    HStack {
                        CurrentSongThumbnail()
                        VStack {
                            SongTitle()
                            ProgressBar()
                                SongController()
                        }
                    }
                    HStack {
                        Lyrics()
                        ExpandLyrics()
                    }
                    SongList()
                }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .edgesIgnoringSafeArea(.all)
    }
}
