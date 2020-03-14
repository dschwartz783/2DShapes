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
        self.primarySceneView.scene = nil
        
        //ensure that the number of points entered can be converted to an integer
        
        if let numPoints = Int(self.pointsTextField.stringValue) {
            let numPoints = Double(numPoints)
            primarySceneView.scene = nil
            
            var k: Double = 0
            
            let scn = SCNScene()
            
            for i in stride(from: 0, to: Double.pi * 2, by: Double.pi * 2 / numPoints) {
                calcQueue.async {
                    for j in stride(from: i, to: Double.pi * 2, by: Double.pi * 2 / numPoints){
                        let positionA = SCNVector3(sin(i), cos(i), k)
                        
                        let positionB = SCNVector3(sin(j), cos(j), k)
                        
                        let newNode = self.line(from: positionA, to: positionB)!
                        
                        let colorMaterial = SCNMaterial()
                        colorMaterial.diffuse.contents = NSColor.red
                        newNode.geometry!.firstMaterial = colorMaterial
                        scn.rootNode.addChildNode(newNode)
                    }
        //                                        k += 0.01 // enable this for fun times
                }
            }
            
            calcQueue.sync(flags: .barrier) {
                self.primarySceneView.scene = scn
            }
        }
    }
    
    func line(from p1: SCNVector3, to p2: SCNVector3) -> SCNNode? {
        // Draw a line between two points and return it as a node
        var indices: [Int32] = [0, 1]
        let positions = [p1, p2]
        let vertexSource = SCNGeometrySource(vertices: positions)
        let indexData = Data(bytes: &indices, count:MemoryLayout<Int32>.size * indices.count)
        let element = SCNGeometryElement(data: indexData, primitiveType: .line, primitiveCount: 1, bytesPerIndex: MemoryLayout<Int32>.size)
        let line = SCNShape(sources: [vertexSource], elements: [element])
        let lineNode = SCNNode(geometry: line)
        return lineNode
    }
}

