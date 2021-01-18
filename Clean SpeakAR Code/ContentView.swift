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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(isSpeakerPlaced: $isSpeakerPlaced)
                .edgesIgnoringSafeArea(.all)
            
            if isSpeakerSelected && !isSpeakerPlaced{
                PlacementButton(isSpeakerSelected: $isSpeakerSelected, isSpeakerPlaced: $isSpeakerPlaced)
            }
            
            else {
                SpeakerButton(isSpeakerSelected: $isSpeakerSelected, isSpeakerPlaced: $isSpeakerPlaced)
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
            do {
                let model = try Entity.loadModel(named: "Speaker")
                let clone = model.clone(recursive: true)

                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(clone)
                uiView.scene.addAnchor(anchorEntity)
            } catch {
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
