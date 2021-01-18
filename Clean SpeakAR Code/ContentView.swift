//
//  ContentView.swift
//  Clean SpeakAR Code
//
//  Created by Daniel Jung on 1/15/21.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @State private var isSpeakerSelected = false
    @State private var isSpeakerPlaced = false
    @State private var isMusicControls = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(isSpeakerPlaced: $isSpeakerPlaced)
                .edgesIgnoringSafeArea(.all)
            VStack {
                MusicControlsButton(isMusicControls: $isMusicControls)
                
                if isSpeakerSelected && !isSpeakerPlaced {
                    PlacementButton(isSpeakerSelected: $isSpeakerSelected, isSpeakerPlaced: $isSpeakerPlaced)
                }
                
                else {
                    SpeakerButton(isSpeakerSelected: $isSpeakerSelected, isSpeakerPlaced: $isSpeakerPlaced)
                }
            }
            if isMusicControls {
                MusicControlsView(isMusicControls: $isMusicControls)
                    //TODO: transition is only applied when loading in the MusicControlsView. I need there to be transition loading out of MusicControlsView too. Also, why is it stutter-y? transition's not smooth. is the main content view working too hard making it lag or something
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var isSpeakerPlaced: Bool
    
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
            print("DEBUG: placing speaker now...")

            let model = try! Entity.loadModel(named: "Apple")
            //let clone = model.clone(recursive: true)

            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(model)
            uiView.scene.addAnchor(anchorEntity)
            
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
