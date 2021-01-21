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
                              SongTitle()
                              ProgressBar()
                                  .padding(.top, 10)
                                  .padding(.bottom, 10)
                                  SongController()
                            Spacer()

                          }
                          .background(Color.black.opacity(0.25))
                          .frame(width: 171.6, height:171.6)
                          .cornerRadius(8)

                  }
                  .padding(.bottom, 25)
                  .padding(.horizontal, 25)
                  
                ScrollView(.vertical) {
                    SongList()
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 45)
                .cornerRadius(8)
                  
              }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//          .background(Color.red)
        .edgesIgnoringSafeArea(.all)
    }
}
