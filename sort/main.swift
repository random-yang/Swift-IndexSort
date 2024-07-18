import Foundation

// gen random data
let cameraForward: SIMD4<Float> = [0.0, 0.0, -1.0, 1]
let vertexCount: UInt32 = 500000
var positions: [Float] = []

for _ in 0..<vertexCount {
    let x = Float(arc4random_uniform(1000)) / 100.0
    let y = Float(arc4random_uniform(1000)) / 100.0
    let z = Float(arc4random_uniform(1000)) / 100.0
    positions.append(contentsOf: [x, y, z])
}

var depthBuffer: [Int32] = [Int32](repeating: 0, count: Int(vertexCount))
var depthIndex: [UInt32] = [UInt32](repeating: 0, count: Int(vertexCount))

let startTime = CFAbsoluteTimeGetCurrent()
for i in 0..<10 {
    sort(
        cameraForward: cameraForward,
        positions: positions,
        vertexCount: vertexCount,
        depthBuffer: &depthBuffer,
        depthIndex: &depthIndex
    )
}

let endTime = CFAbsoluteTimeGetCurrent()

print("Elapsed time: \(endTime - startTime) seconds")
