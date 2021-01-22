//
//  CurrentSongThumbnail.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/18/21.
//

import SwiftUI

struct CurrentSongThumbnail: View {
    var body: some View {
        
            Image("Music Thumbnail")
                .resizable()
                .frame(width:171.6, height: 171.6)
                .cornerRadius(8)

                .onTapGesture {
                    print("DEBUG: Thumbnail tapped")
        }
                //only for testing purposes. remove later.
                .background(Color.black.opacity(0.50))
    }
}
