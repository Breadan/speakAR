//
//  CurrentSongThumbnail.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/18/21.
//

import SwiftUI

struct CurrentSongThumbnail: View {
    var body: some View {
        
            Image("Apple Homepod")
                .resizable()
                .frame(width:171.6, height: 171.6)
                .cornerRadius(8)

                .onTapGesture {
                    print("tapped on Current Song Thumbnail")
        }
                //only for testing purposes. remove later.
                .background(Color.black.opacity(0.25))
    }
}
