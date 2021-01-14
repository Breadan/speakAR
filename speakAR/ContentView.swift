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
    //i think ? means optional...
    @State private var modelConfirmedForPlacement: Model?
    
    
    private var models: [Model] = {
    //Dynamically get model fileNames
        let filemanager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try?
                filemanager.contentsOfDirectory(atPath: path)
        else {
            return []
        }
    
        var availableModels: [Model] = []
        for fileName in files where
            fileName.hasSuffix("usdc") {
            let modelName = fileName.replacingOccurrences(of: ".usdc", with: "")
            let model = Model(modelName: modelName)
            
            availableModels.append(model)
        }
        return availableModels
    }()
    
    
    
    
    var body: some View {
        //look up Zstack priority order
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement).edgesIgnoringSafeArea(.all)
            
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            } else {
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
            
            if let modelEntity = model.modelEntity {
                print("DEBUG: adding model to scene - \(model.modelName)")
                
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                //.clone creates copy, but references original copy.  
                
                uiView.scene.addAnchor(anchorEntity)
            } else {
                print("DEBUG: Unable to load modelEntity for \(model.modelName)")
            }
            
//      if let modelName = self.modelConfirmedForPlacement
//            let fileName = modelName + ".usdc"
//            let modelEntity = try! ModelEntity.load(named: fileName)
//            //now we created model Entity, now we create Anchor entity. in reality kit, all objects have to be attached to anchor.
//            let anchorEntity = AnchorEntity(plane: .any)
//            //any means any type of plane as anchor.
//            anchorEntity.addChild(modelEntity)
//
//            uiView.scene.addAnchor(anchorEntity)
            
            
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil

            }
        }
    }
    
}


struct SpeakerView: View {
    //creates a binding variable
    //binding variable = variable that has his source of truth outside of the speakerview struct. passing it as binding variable allows re
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    
    var models: [Model]
    
    var body: some View {
        // look up what ScrollView does
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                //ForEach loops ??
                ForEach(0 ..< self.models.count) {
                    //what is index in
                    index in
                    //structures & classes. Colons are structures, and everything inside are constructors to initialize structure.
                    Button(action: {
                        print("DEBUG: selected \(self.models[index].modelName)")
                        
                        self.selectedModel = self.models[index]
                        
                        //changes binding variable state
                        self.isPlacementEnabled = true
                    }) {
                        //wrap vs unwrapping
                        Image(uiImage: self.models[index].image)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
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
