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


struct ContentView : View {
    @State private var isSpeakerSelected = false
    @State private var isSpeakerPlaced = false
    @State private var isMusicControls = false

    // Setting our stored property to the closure's returned value, NOT the actual closure itself (i.e., we called the closure using the '()' function notation to RETURN value)
    private var models: Model? = { () -> Model in
        let model = Model(modelName: "Speaker", fileExt: ".usdz")
        return model
    }()
    
    private var songs: [Song?] = { () -> [Song] in
        var songs: [Song] = []
       
        let FM = FileManager.default
        
        if let resourcesPath = try? FM.contentsOfDirectory(atPath: Bundle.main.bundlePath) {
            var songURLs = [String]()
            for resource in resourcesPath where resource.hasSuffix("mp3") {
                print("DEBUG: Found resource \(resource)")
                songURLs.append(resource)
            }
            
            // Use a closure to efficiently operate on each String from 'songURLs' to append to 'songs'
            songURLs.forEach { (songURL: String) -> Void in
                // Ensure specified song URL has a .extension by optionally bindng String.Index?
                if let extIndex: String.Index = songURL.firstIndex(of:".") {
                    songs.append(
                        // Appending instances of Songs created from songURL substrings
                        Song(songName: String(songURL[..<extIndex]),
                             fileExt: String(songURL[extIndex..<songURL.endIndex])
                        ))
                } else {
                    print("ERROR: Invalid song URL!")
                }
            }
            
        } else {
            print("DEBUG: No song files found")
            return []
        }
        
        return songs
    }()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(isSpeakerPlaced: $isSpeakerPlaced, speakerModel: models, speakerSongs: songs)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if isMusicControls {
                    MusicControlsView(isMusicControls: $isMusicControls)
                        //TODO: transition is only applied when loading in the MusicControlsView. I need there to be transition loading out of MusicControlsView too. Also, why is it stutter-y? transition's not smooth. is the main content view working too hard making it lag or something
                        .transition(.move(edge: .bottom))

                }
                else {
                    MusicControlsButton(isMusicControls: $isMusicControls)
                    
                    if isSpeakerSelected && !isSpeakerPlaced {
                        PlacementButton(isSpeakerSelected: $isSpeakerSelected, isSpeakerPlaced: $isSpeakerPlaced)
                    }
                    
                    else {
                        SpeakerButton(isSpeakerSelected: $isSpeakerSelected, isSpeakerPlaced: $isSpeakerPlaced)
                    }
                }
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var isSpeakerPlaced: Bool
    var speakerModel: Model?
    var speakerSongs: [Song?]
    
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
            if let speaker = speakerModel?.modelEntity {
                print("DEBUG: Placed Speaker Model")
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(speaker)
                uiView.scene.addAnchor(anchorEntity)
                // Lets play more than one song!
                let randSongIndex = Int.random(in: 0..<speakerSongs.count)
                
                if let song = speakerSongs[randSongIndex]?.songResource {
                    print("DEBUG: Playing Speaker Song: \(speakerSongs[randSongIndex]!.songName)")
                    let audioController = speaker.prepareAudio(song)
                    audioController.play()
                }
                
            } else {                
                print("ERROR: LoadModel Error")
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
