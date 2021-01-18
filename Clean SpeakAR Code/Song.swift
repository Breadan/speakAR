//
//  Music.swift
//  Clean SpeakAR Code
//
//  Created by Brendan Yang on 1/17/21.
//
// Class to asynchronously load music. Only .mp3 files supported!

import UIKit
import RealityKit
import Combine

class Song {
    var isLoaded: Bool = false
    var songName: String
    var songResource: AudioFileResource?
    
    private var cancellable: AnyCancellable?
    
    init(songName: String, fileExt: String) {
        self.songName = songName
        let fileName = songName + fileExt
        
        self.cancellable = AudioFileResource.loadAsync(named: fileName,
                                                       in: nil,
                                                       inputMode: .spatial,
                                                       loadingStrategy: .preload,
                                                       shouldLoop: true)
            .sink() { completionError in
                if(!self.isLoaded) {
                    print("ERROR: \(completionError) non-value received on request completion")
                } else {
                    print("DEBUG: Request completed, tearing down sink stream...")
                }
                self.cancellable?.cancel()
                
            } receiveValue: { value in
                print("SUCCESS: \(value) value received on request completion")
                self.isLoaded = true
                self.songResource = value
            }
    }
}

//let audioResource = try AudioFileResource.load(named: "Stan Forebee & Kyle McEvoy - Sunrise On Southey Street.mp3",
//                                       in: nil,
//                                       inputMode: .spatial,
//                                       loadingStrategy: .preload,
//                                       shouldLoop: true)

