//
//  ViewController.swift
//  2DShapes
//
//  Created by David Schwartz on 1/29/17.
//  Copyright © 2017 DDS Programming. All rights reserved.
//

import Cocoa
import SceneKit
import GLKit

class ViewController: NSViewController, SCNSceneRendererDelegate {
    
    @IBOutlet weak var primarySceneView: SCNView!
    @IBOutlet weak var pointsTextField: NSTextField!
    
    let calcQueue = DispatchQueue(label: "calcQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    @IBAction func drawClicked(_ sender: NSButton) {
        
        self.primarySceneView.delegate = self
        
        if let numPoints = Double(self.pointsTextField.stringValue) {
            
            let mainNode = SCNNode()
            
            for i in stride(from: 0, to: M_PI * 2, by: M_PI * 2 / numPoints) {
                for j in stride(from: i, to: M_PI * 2, by: M_PI * 2 / numPoints){
                    
                    let positionA = SCNVector3(sin(i), cos(i), 0)
                    
                    let positionB = SCNVector3(sin(j), cos(j), 0)
                    
                    let newNode = self.lineBetweenNodeA(positionA, positionB: positionB)
                    
                    mainNode.addChildNode(newNode)
                }
            }
            
            
            
            let returnScene = SCNScene()
            
            mainNode.childNodes.forEach({ (node) in
                let colorMaterial = SCNMaterial()
                colorMaterial.diffuse.contents = NSColor.red
                
                node.geometry!.firstMaterial = colorMaterial
            })
            
            returnScene.rootNode.addChildNode(mainNode.flattenedClone())
            
            self.primarySceneView.scene = returnScene
        }
    }
    
    func lineBetweenNodeA(_ positionA: SCNVector3, positionB: SCNVector3) -> SCNNode
    {
        let positions: [Float] = [Float(positionA.x), Float(positionA.y), Float(positionA.z), Float(positionB.x), Float(positionB.y), Float(positionB.z)]
        let positionData = Data(bytes: positions, count: MemoryLayout<Float>.size * positions.count)
        let indices: [Int32] = [0, 1]
        let indexData = Data(bytes: indices, count: MemoryLayout<Int32>.size * indices.count)
        
        let source = SCNGeometrySource(data: positionData, semantic: SCNGeometrySource.Semantic.vertex, vectorCount: indices.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: MemoryLayout<Float>.size, dataOffset: 0, dataStride: MemoryLayout<Float>.size * 3)
        let element = SCNGeometryElement(data: indexData, primitiveType: SCNGeometryPrimitiveType.line, primitiveCount: indices.count, bytesPerIndex: MemoryLayout<Int32>.size)
        
        let line = SCNGeometry(sources: [source], elements: [element])
        return SCNNode(geometry: line)
    }
}

