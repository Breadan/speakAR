//
//  SongController.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/18/21.
//

import SwiftUI

struct SongController: View {
    //later set this to binding, put state variable else so it syncs with when music starts
    @State var isPlaying = false
    
    var body: some View {
        HStack {
            Button(action: {
                print("DEBUG: back button selected")
            }) {
                Image(systemName: "backward.fill")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            }
            if isPlaying {
                Button(action: {
                    print("DEBUG: pause button selected")
                    isPlaying = false
                    
                }) {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            else {
                Button(action: {
                    print("DEBUG: play button selected")
                    isPlaying = true
                    
                }) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            
            Button(action: {
                print("DEBUG: next button selected")
            }) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
