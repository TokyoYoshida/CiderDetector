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

//3Dオブジェクトの検出
class ViewController: UIViewController, ARSCNViewDelegate {
   @IBOutlet var sceneView: ARSCNView!

   //ロード時に呼ばれる
   override func viewDidLoad() {
       super.viewDidLoad()
       
       //シーンの作成
       sceneView.scene = SCNScene()
       
       //光源の有効化
       sceneView.autoenablesDefaultLighting = true;
       
       //ARSCNViewデリゲートの指定
       sceneView.delegate = self
   }
   
   //ビュー表示時に呼ばれる
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       //ARWorldTrackingConfigurationの生成
       let configuration = ARWorldTrackingConfiguration()

       //3Dオブジェクト情報のリソースの指定
       configuration.detectionObjects = ARReferenceObject.referenceObjects(
           inGroupNamed: "AR Resources", bundle: nil)!
       
       //セッションの開始
       sceneView.session.run(configuration)
   }

   //ビュー非表示時に呼ばれる
   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       //セッションの一時停止
       sceneView.session.pause()
   }
   
   //ARアンカー追加時に呼ばれる
   func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
       DispatchQueue.main.async {
        guard let objectAnchor = anchor as? ARObjectAnchor else { return }
           //ARAnchorの名前がgebaraの時
           if (anchor.name == "cyder") {
            // 直方体ジオメトリを作成
            let extent = objectAnchor.referenceObject.extent
            let geometry = SCNBox(width: CGFloat(extent.x), height: CGFloat(extent.y),
            length: CGFloat(extent.z), chamferRadius: 0.01)
            if let material = geometry.firstMaterial {
            material.diffuse.contents = #imageLiteral(resourceName: "bubble")
            material.lightingModel = .physicallyBased }
            // 直方体ジオメトリを持つノードを作成
            let boxNode = SCNNode(geometry: geometry)
            boxNode.position = SCNVector3(objectAnchor.referenceObject.center)
            DispatchQueue.main.async(execute: {
            node.addChildNode(boxNode)
                
            })
           }
       }
   }
}
