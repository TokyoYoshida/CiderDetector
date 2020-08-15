//
//  ViewController.swift
//  CiderDetector
//
//  Created by TokyoMac on 2020/07/19.
//  Copyright © 2020 TokyoMac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
   @IBOutlet var sceneView: ARSCNView!

   override func viewDidLoad() {
       super.viewDidLoad()
       
       sceneView.scene = SCNScene()
       
       sceneView.autoenablesDefaultLighting = true;
       
       sceneView.delegate = self
   }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       let configuration = ARWorldTrackingConfiguration()

       configuration.detectionObjects = ARReferenceObject.referenceObjects(
           inGroupNamed: "AR Resources", bundle: nil)!
       
       sceneView.session.run(configuration)
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       sceneView.session.pause()
   }
   

func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
       DispatchQueue.main.async {
        guard let objectAnchor = anchor as? ARObjectAnchor else { return }
           if (anchor.name == "cyder") {

            let extent = objectAnchor.referenceObject.extent
            let geometry = SCNBox(width: CGFloat(extent.x), height: CGFloat(extent.y),
            length: CGFloat(extent.z), chamferRadius: 0.01)
            if let material = geometry.firstMaterial {
                material.diffuse.contents = UIColor.blue
            material.lightingModel = .physicallyBased }

            let boxNode = SCNNode(geometry: geometry)
            boxNode.position = SCNVector3(objectAnchor.referenceObject.center)
            DispatchQueue.main.async(execute: {
            node.addChildNode(boxNode)
                
            })
           }
       }
   }
}
