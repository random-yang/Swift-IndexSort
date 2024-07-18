//
//  indexSort.swift
//  sort
//
//  Created by RandomYang on 2024/7/18.
//

import Foundation

func sort(cameraForward: SIMD4<Float>, positions: [Float], vertexCount: UInt32,
          depthBuffer: inout [Int32], depthIndex: inout [UInt32]) {
    var starts: [UInt32] = [UInt32](repeating: 0, count: 256 * 256)
    var counts: [UInt32] = [UInt32](repeating: 0, count: 256 * 256)
    var minDepth: Int32 = Int32.max
    var maxDepth: Int32 = Int32.min
    
    for i in 0..<vertexCount {
        let x = positions[3 * Int(i) + 0]
        let y = positions[3 * Int(i) + 1]
        let z = positions[3 * Int(i) + 2]
        let position = SIMD4(x, y, z, 1)
        let depth = Int32((cameraForward * position).sum() * 4096)
        depthBuffer[Int(i)] = depth
        
        if depth > maxDepth {
            maxDepth = depth
        }
        if depth < minDepth {
            minDepth = depth
        }
    }
    
    let depthRange: UInt32 = 256 * 256
    let depthInv = Float(depthRange - 1) / Float(maxDepth - minDepth)
    counts = [UInt32](repeating: 0, count: Int(depthRange))
    
    for i in 0..<vertexCount {
        depthBuffer[Int(i)] = Int32((Float(depthBuffer[Int(i)]) - Float(minDepth)) * depthInv)
        counts[Int(depthBuffer[Int(i)])] += 1
    }
    
    starts[0] = 0
    for i in 1..<depthRange {
        starts[Int(i)] = starts[Int(i - 1)] + counts[Int(i - 1)]
    }
    
    depthIndex = [UInt32](repeating: 0, count: Int(vertexCount))
    for i in 0..<vertexCount {
        depthIndex[Int(starts[Int(depthBuffer[Int(i)])])] = i
        starts[Int(depthBuffer[Int(i)])] += 1
    }
}


