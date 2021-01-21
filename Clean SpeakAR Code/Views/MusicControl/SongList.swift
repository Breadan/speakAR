//
//  SongList.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/18/21.
//

import SwiftUI

struct SongList: View {
    var body: some View {
        
        VStack(spacing: 20) {
            ForEach(0..<30) {
                Text("Song number \($0)")
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.25))
    }
}
