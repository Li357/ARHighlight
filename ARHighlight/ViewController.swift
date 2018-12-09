//
//  ViewController.swift
//  ARHighlight
//
//  Created by Andrew Li on 12/2/18.
//  Copyright © 2018 Andrew Li. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        
        if let path = Bundle.main.path(forResource: "HighlightTechnique", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                sceneView.technique = SCNTechnique(dictionary: dict)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        let box = SCNNode(geometry: boxGeometry)
        box.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.extent.y, planeAnchor.center.z)
        box.categoryBitMask = 2
        box.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
        box.geometry?.firstMaterial?.isDoubleSided = true
        node.addChildNode(box)
    }
}
