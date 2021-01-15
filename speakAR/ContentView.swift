//
//  ContentView.swift
//  Spatial Speaker
//
//  Created by Daniel Jung on 1/11/21.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    //uses a state variable to show / hide different views using the if else statement below
    @State private var isPlacementEnabled = false
    @State private var selectedModel: Model?
    @State private var modelConfirmedForPlacement: Model?
    @State private var isModelPlaced = false
    
    
    private var models: Model = {
        let model = Model(inputtedModelName: "Apple")
        return model
    }()
    
    
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement).edgesIgnoringSafeArea(.all)
            
            if self.isPlacementEnabled {
                //Placement Confirm View
                PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            } else {
                //Speaker Select View
                SpeakerView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, models: self.models)
                //the dollar sign allows it to have read and write access. without it it would just be read access.
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
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
        if let model = self.modelConfirmedForPlacement {
            
            //.clone creates copy, but references original copy.
            if let modelEntity = model.modelEntity {
                print("DEBUG: adding model to scene - \(model.modelName)")
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity)
            
                
                
                //let howlLoaded = try? Entity.loadAsync(contentsOf: howlURL!)
                let resource = try! AudioFileResource.load(named: "Howl's Moving Castle.mp3" , in: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: true)
                
                let audioController = modelEntity.prepareAudio(resource)
                audioController.play()
                
                //modelEntity.prepareAudio()
                
                //yes sirrrrrrrrrrrrrrr
                //AudioResource.InputMode.spatial
                
                
            } else {
                print("DEBUG: Unable to load modelEntity for \(model.modelName)")
            }
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
                
            }
        }
        
    }
    
}


struct SpeakerView: View {
    //binding variable = variable that has his source of truth outside of the speakerview struct. passing it as binding variable allows re
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    var models: Model
    
    var body: some View {
        HStack(spacing: 30) {
            Button(action: {
                print("DEBUG: selected \(self.models.modelName)")
                
                self.selectedModel = self.models
                self.isPlacementEnabled = true
            }) {
                Image(uiImage: self.models.image)
                    .resizable()
                    .frame(height: 100)
                    .aspectRatio(1/1, contentMode: .fit)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.white.opacity(1))
            .cornerRadius(120)
        }
        .padding(20)
    }
}

struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    var body: some View {
        HStack {
            // Cancel button
            Button(action: {
                print("DEBUG: model placement cancelled")
                
                self.resetPlacementParameters()
            }) {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            //confirm button
            Button(action: {
                print("DEBUG: model placement confirmed")
                self.modelConfirmedForPlacement = self.selectedModel
                
                self.resetPlacementParameters()
            }) {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    
    func resetPlacementParameters() {
        self.isPlacementEnabled = false
        self.selectedModel = nil
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
