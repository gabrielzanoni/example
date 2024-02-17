func anglesToFace() -> (x: Float, y: Float) {
    var faceTransform = faceNode.transform
    let currentCameraTransform = camera.transform

    faceTransform.m41 = trackedEyePosition.x
    faceTransform.m42 = trackedEyePosition.y
    faceTransform.m43 = trackedEyePosition.z

    cameraNode.transform = SCNMatrix4.init(currentCameraTransform)
    originNode.transform = SCNMatrix4Identity

    // Translation matrix to center of device
    let translation = simd_float4x4(
        SIMD4<Float>(1, 0, 0, 0),
        SIMD4<Float>(0, 1, 0, 0),
        SIMD4<Float>(0, 0, 1, 0),
        SIMD4<Float>(Device.cameraToCenterX, -(Device.cameraToCenterY), 0, 1)
    )

    deviceCenterNode.simdTransform = cameraNode.simdTransform * translation

    // Converts a transform from the node’s local coordinate space to that of another node.
    let transformInCameraSpace = originNode.convertTransform(faceTransform, to: deviceCenterNode)
    let faceTransformFromCamera = simd_float4x4(transformInCameraSpace)
    
    // [...] some math happening here

    faceNode.transform = transformInCameraSpace
    return (x: angleToFaceX, y: angleToFaceY)
}
