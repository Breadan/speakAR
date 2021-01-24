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
    // These private instance variables all initialize once on app launch
    @State private var isSpeakerSelected = false
    @State private var isSpeakerPlaced = false
    @State private var isMusicControls = false
    
    // Setting our stored property to the closure's returned value, NOT the actual closure itself (i.e., we called the closure using the '()' function notation to RETURN value)
    private var models: Model? = { () -> Model in
        let model = Model(modelName: "Speaker", fileExt: ".usdz")
        return model
    }()
    
    @State private var audioController: AudioPlaybackController? = nil
    @State private var songs: [String:Song] = loadSongList()
    @State private var songsQueue: (loadedSongURLs: [String], queueIndex: Int?) = ([], nil)
    @State private var isTraversed: Bool = false
    @State private var isPlaying: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(isSpeakerPlaced: $isSpeakerPlaced, isTraversed: $isTraversed, isPlaying: $isPlaying, audioController: $audioController, speakerModels: models, songs: songs, songsQueue: songsQueue)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: (isMusicControls ? 15 : 0))
                
            VStack {
                if isMusicControls {
                    MusicControlsView(audioController: $audioController, isMusicControls: $isMusicControls, songs: $songs, songsQueue: $songsQueue, isTraversed: $isTraversed, isPlaying: $isPlaying)
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
    @Binding var isTraversed: Bool
    @Binding var isPlaying: Bool
    
    @Binding var audioController: AudioPlaybackController?
    var speakerModels: Model?
    var songs: [String:Song]
    var songsQueue: (loadedSongURLs: [String], queueIndex: Int?)
    

    
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
        
        if isSpeakerPlaced || isTraversed {
            // Speaker init
            if let speaker = speakerModels?.modelEntity {
                // Speaker setup
                if isSpeakerPlaced {            // only place new speaker if explicitly built
                    print("DEBUG: Placed Speaker Model")
                    let anchorEntity = AnchorEntity(plane: .any)
                    anchorEntity.addChild(speaker)
                    uiView.scene.addAnchor(anchorEntity)
                }
            
                // Song setup
                if(songsQueue.loadedSongURLs.count > 0) {
                    if let currentIndex = songsQueue.queueIndex {
                        print("DEBUG: Loaded song: \(songsQueue.loadedSongURLs[currentIndex])")
                        DispatchQueue.main.async {
                            if audioController != nil {
                                audioController!.stop()
                            }
                            audioController = speaker.prepareAudio(songs[songsQueue.loadedSongURLs[currentIndex]]!.songResource!)
                        }
                    } else {
                        print("DEBUG: No song queued")
                    }

                } else {
                    print("DEBUG: No songs available")
                }
                
            } else {
                print("ERROR: Load Model Error")
            }
            
            DispatchQueue.main.async {
                isSpeakerPlaced = false
                isTraversed = false
            }
        }
        
        
        if isPlaying || !isPlaying {    // Universally true logic ensures any song control play/pause updates
            if audioController != nil { // If 'audioController' already initialized from confirmed speaker placement
                if isPlaying {
                    print("DEBUG: Playing song...")
                    audioController!.play()
                } else {
                    print("DEBUG: Pausing song...")
                    audioController!.pause()
                }
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
