//
//  Model.swift
//  Clean SpeakAR Code
//
//  Created by Brendan Yang on 1/17/21.
//
// Class to asynchronously load model. All RealityKit extensions supported.

import UIKit
import RealityKit
import Combine

class Model {
    var isLoaded: Bool = false
    var modelName: String
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable?    // The first closure of .sink() always runs, even if load is successful, to tear down stream and so we can cancel our cancellable
    
    init(modelName: String, fileExt: String) {
        self.modelName = modelName
        let fileName = modelName + fileExt
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink() { (completionError: Subscribers.Completion<Error>) -> Void in
                if(!self.isLoaded) {
                    print("ERROR: \(completionError) non-value received on request completion")
                } else {
                    print("DEBUG: Request completed, tearing down sink stream...")
                }
                self.cancellable?.cancel() // Cancel our cancellable
                
            } receiveValue: { (value: ModelEntity) -> Void in
                print("SUCCESS: \(value) value received on request completion")
                self.isLoaded = true
                self.modelEntity = value
            }
    }
}

