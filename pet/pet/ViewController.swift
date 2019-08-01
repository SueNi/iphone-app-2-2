//
//  ViewController.swift
//  pet
//
//  Created by GWC2 on 7/24/19.
//  Copyright © 2019 GWC. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    //let config = ARWorldTrackingConfiguration()
    //var petNode: SCNNode!
    //let petNodeName = "Dog"
    var petNode: SCNNode!
    var index = 0
    var petScene: SCNScene!
    var petNodeNameArray: [String] = ["Sheep", "Shark", "Dog", "Fox"]
    var petSceneArray: [String] = ["animal.scnassets/Sheep.scn", "animal.scnassets/shark.scn","animal.scnassets/Dog.scn", "animal.scnassets/Fox.scn"]
    override func viewDidLoad() {
        super.viewDidLoad()
        addPet()
        addtext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    func addPet(x: Float = 0, y: Float = 0, z: Float = 0){
        if index >= petNodeNameArray.count{
            index = 0
        }
        petScene = SCNScene(named: petSceneArray[index])
        petNode = petScene.rootNode.childNode(withName: petNodeNameArray[index], recursively: true)
        petNode.scale = SCNVector3(0.1, 0.1, 0.1)
        petNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(petNode)
    }
    
    func addtext(){
        let text = SCNText(string: "My pet", extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.purple
        text.materials = [material]
        let node = SCNNode()
        node.position = SCNVector3(x: 0.0, y: 0.02, z: -0.1)
        node.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        node.geometry = text
        sceneView.scene.rootNode.addChildNode(node)
        let fade = SCNAction.fadeOut(duration: 10.0)
        node.runAction(fade)
    }

    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        index += 1
        
    }
    @IBAction func tap(_ sender: Any) {
        let tapLocation = (sender as AnyObject).location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else { let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultsWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultsWithFeaturePoints.worldTransform.translation
                addPet(x: translation.x, y: translation.y, z: translation.z)
            }
            return }
        node.removeFromParentNode()
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

