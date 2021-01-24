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

class Song: Identifiable, Equatable {
    let id = UUID()
    static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.songURL == rhs.songURL || lhs.songName == rhs.songName
    }
    
    let songURL: String
    let songName: String      // this is without the file extension
    //let songArtist: String
    //let songGenre: String
    var songDuration: Double {
        // placeholder
        return 120.0
    }
    
    var songResource: AudioFileResource?

    
    init(URL: String) {
        self.songURL = URL
        self.songName = String(URL[...URL.firstIndex(of: ".")!])
    }
    
    func requestSong(songURL: String) -> () {
        var isLoaded: Bool = false
        
        var cancellable: AnyCancellable?
        cancellable = AudioFileResource.loadAsync(named: songURL,
                                                       in: nil,
                                                       inputMode: .spatial,
                                                       loadingStrategy: .preload,
                                                       shouldLoop: true)
            .sink() { completionError in
                if(!isLoaded) {
                    print("ERROR: \(completionError) non-value received on request completion")
                } else {
                    print("DEBUG: Request completed, closing stream...")
                }
                cancellable?.cancel()
                
            } receiveValue: { value in
                print("SUCCESS: \(value) value received on request completion")
                isLoaded = true
                self.songResource = value
            }
    }
}
