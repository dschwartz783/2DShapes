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
    let addQueue = DispatchQueue(label: "addQueue")
    
    override func viewDidLoad() {
        self.primarySceneView.delegate = self
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        glLineWidth(1)
    }
    
    @IBAction func drawClicked(_ sender: NSButton) {
        
        //ensure that the number of points entered can be converted to an integer
        
        if let numPoints = Int(self.pointsTextField.stringValue) {
            let numPoints = Double(numPoints)
            primarySceneView.scene = nil
            
            var k: Double = 0
            
            self.primarySceneView.scene = SCNScene()
            
            for i in stride(from: 0, to: Double.pi * 2, by: Double.pi * 2 / numPoints) {
                calcQueue.async {
                    for j in stride(from: i, to: Double.pi * 2, by: Double.pi * 2 / numPoints){
                        let positionA = SCNVector3(sin(i), cos(i), k)
                        
                        let positionB = SCNVector3(sin(j), cos(j), k)
                        
                        let newNode = self.lineBetweenNodeA(positionA, positionB: positionB)
                        
                        let colorMaterial = SCNMaterial()
                        colorMaterial.diffuse.contents = NSColor.red
                        newNode.geometry!.firstMaterial = colorMaterial
                        self.primarySceneView.scene!.rootNode.addChildNode(newNode)
                    }
                    
//                                        k += 0.01 // enable this for fun times
                }
            }
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

