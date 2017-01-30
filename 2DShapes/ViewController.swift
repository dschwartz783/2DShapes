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
    
    @IBAction func drawClicked(_ sender: NSButton) {
        
        var k: Double = 0
        if let numPoints = Double(self.pointsTextField.stringValue) {
            
            let returnScene = SCNScene()
            
            var addQueueCount = 0
            
            for i in stride(from: 0, to: M_PI * 2, by: M_PI * 2 / numPoints) {
                for j in stride(from: i, to: M_PI * 2, by: M_PI * 2 / numPoints){
                    
                    calcQueue.async {
                        let positionA = SCNVector3(sin(i), cos(i), k)
                        
                        let positionB = SCNVector3(sin(j), cos(j), k)
                        
                        let newNode = self.lineBetweenNodeA(positionA, positionB: positionB)
                        
                        let colorMaterial = SCNMaterial()
                        colorMaterial.diffuse.contents = NSColor.red
                        newNode.geometry!.firstMaterial = colorMaterial
                        
                        self.addQueue.async {
                            addQueueCount += 1
                            returnScene.rootNode.addChildNode(newNode)
                            
                            self.primarySceneView.scene = returnScene
                        }
                    }
                    
                    //k += 0.001 // enable this for fun times
                }
            }
            
            calcQueue.async(flags: .barrier, execute: {
                self.addQueue.async(flags: .barrier, execute: { 
                    if addQueueCount == 0 {
                        self.primarySceneView.delegate = self
                    }
                })
            })
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

