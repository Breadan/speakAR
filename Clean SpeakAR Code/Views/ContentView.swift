//
//  ContentView.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/15/21.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

enum loadStrat: UInt {
    case onAppLaunch
    case realTime
}

struct ContentView : View {
    @State private var isSpeakerSelected = false
    @State private var isSpeakerPlaced = false
    @State private var isMusicControls = false
    
    private static var resourceLoadStrat = loadStrat.onAppLaunch
    
    // Setting our stored property to the closure's returned value, NOT the actual closure itself (i.e., we called the closure using the '()' function notation to RETURN value)
    private var models: Model? = { () -> Model in
        let model = Model(modelName: "Speaker", fileExt: ".usdz")
        return model
    }()
    
    @State private var songs: [String:Song?] = { () -> [String:Song?] in
        let FM = FileManager.default
        var songs = Dictionary<String,Song?>()
        if let resourcesPath = try? FM.contentsOfDirectory(atPath: Bundle.main.bundlePath) {
            for resourceURL in resourcesPath where resourceURL.hasSuffix("mp3") {
                print("DEBUG: Found song resource \(resourceURL)")
                songs[resourceURL] = nil as Song?   // Need to explicitly SET TO 'nil', 'nil' usually inferred as "to remove entry"
            }
            /* This loads resources in loading-screen. We can move loading requests to when the user places the speaker or confirm selects song for speaker. */
            if(resourceLoadStrat == loadStrat.onAppLaunch) {
                // Use a closure to efficiently operate on each String from 'songURLs' to append to 'songs'
                Array(songs.keys).forEach { (songURL: String) -> Void in
                    // Ensure specified song URL has a .extension by optionally bindng String.Index?
                    if let extIndex: String.Index = songURL.firstIndex(of:".") {
                        songs[songURL] =
                            // Pairing 'songURL' key with 'Song' value
                            Song(songName: String(songURL[..<extIndex]),
                                 fileExt: String(songURL[extIndex..<songURL.endIndex]))
                    } else {
                        print("ERROR: Invalid song URL!")
                    }
                }
                print("DEBUG: Requested a total of \(songs.count) song resources")
            }
            else if(resourceLoadStrat == loadStrat.realTime) {
                print("DEBUG: Skipping song pre-requests... using real-time loader")
            }
            
        } else {
            print("DEBUG: No .mp3 song files found")
            return [:]
        }
        return songs
    }()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(isSpeakerPlaced: $isSpeakerPlaced, resourceLoadStrat: ContentView.resourceLoadStrat, speakerModels: models, speakerSongs: $songs)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: (isMusicControls ? 15 : 0))
            
            VStack {
                if isMusicControls {
                    MusicControlsView(isMusicControls: $isMusicControls)
                        //TODO: transition is only applied when loading in the MusicControlsView. I need there to be transition loading out of MusicControlsView too. Also, why is it stutter-y? transition's not smooth. is the main content view working too hard making it lag or something
                        .transition(.move(edge: .bottom))
                }
                else {
                    HStack {
                        Spacer()
                        MusicControlsButton(isMusicControls: $isMusicControls)
                            .padding(.top, 45)
                            .padding(.trailing, 20)
                    }
                    Spacer()
                    if isSpeakerSelected && !isSpeakerPlaced {
                        PlacementButton(isSpeakerSelected: $isSpeakerSelected, isSpeakerPlaced: $isSpeakerPlaced)
                            .padding(.bottom, 50)
                    }
                    
                    else {
                            SpeakerButton(isSpeakerSelected: $isSpeakerSelected, isSpeakerPlaced: $isSpeakerPlaced)
                                .padding(.bottom, 50)
                    }
                }
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var isSpeakerPlaced: Bool
    
    var resourceLoadStrat: loadStrat
    var speakerModels: Model?
    @Binding var speakerSongs: [String:Song?]
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        //configuring stuff i guess
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        //the if statement below adds another config only for LiDAR sensor enabled devices
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if isSpeakerPlaced {
            // Speaker setup
            if let speaker = speakerModels?.modelEntity {
                print("DEBUG: Placed Speaker Model")
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(speaker)
                uiView.scene.addAnchor(anchorEntity)
                
                // Song setup
                let audioController: AudioPlaybackController
                if(speakerSongs.count > 0) {
                    let randSongIndex = Int.random(in: 0..<speakerSongs.count)
                    
                    // Pre-requested song loader
                    if(resourceLoadStrat == loadStrat.onAppLaunch) {
                        if let songResource = Array(speakerSongs.values)[randSongIndex]?.songResource {
                            print("DEBUG: Playing Speaker Song: \(Array(speakerSongs.values)[randSongIndex]!.songName)")
                            audioController = speaker.prepareAudio(songResource)
                            audioController.play()
                        } else {
                            print("ERROR: Load Song Error")
                        }
                    }
                    // Real-time load song loader
                    else if(resourceLoadStrat == loadStrat.realTime) {
                        let songURL = Array(speakerSongs.keys)[randSongIndex]
                        // Init/cache song if not already in dictionary
                        if speakerSongs[songURL]! == nil {
                            print("DEBUG: \(songURL) not cached, caching...")
                            let extIndex = songURL.firstIndex(of:".")!
                            DispatchQueue.main.async {
                                speakerSongs[songURL] = Song(songName: String(songURL[..<extIndex]),
                                                   fileExt: String(songURL[extIndex..<songURL.endIndex]))
                            }
                        }
                        // Load song from dictionary and play
                        if let song = speakerSongs[songURL]! {
                            if let songResource = song.songResource {
                                print("DEBUG: Playing Speaker Song: \(Array(speakerSongs.values)[randSongIndex]!.songName)")
                                audioController = speaker.prepareAudio(songResource)
                                audioController.play()
                            } else {
                                print("ERROR: Load songResource Error")
                            }
                        } else {
                            print("ERROR: Load Song Error - is async request completed?")
                        }
                    }
                    
                } else {
                    print("DEBUG: No songs available")
                }
            } else {                
                print("ERROR: Load Model Error")
            }
            DispatchQueue.main.async {
                isSpeakerPlaced = false
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
