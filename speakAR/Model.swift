//
//  Model.swift
//  Spatial Speaker
//
//  Created by Daniel Jung on 1/13/21.
//

import UIKit
import RealityKit
import Combine
//Combine = asynchronous event-driven framework.


//we made this file so we can load models asynhronously without freezing up UI as we load in ContentView.

class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    //having ?, optional, allows you to deal with "nil".
    init(modelName: String) {
        self.modelName = modelName
        
        self.image = UIImage(named: modelName)!
        
        //asynchronously load.
        let fileName = modelName + ".usdc"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion in
                //handle our error
                print("DEBUG: Unable to load modelEntity for modelName: \(self.modelName)")
            }, receiveValue: {modelEntity in
                //get our modelEntity
                self.modelEntity = modelEntity
                print("DEBUG: successfully loaded modelEntity for modelName: \(self.modelName)")
            })
    }
}
//now go refactor and mess everything up! :D
