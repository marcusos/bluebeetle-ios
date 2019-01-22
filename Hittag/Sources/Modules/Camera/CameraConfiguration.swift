import ModuleArchitecture

struct CameraConfiguration {
    let predictedClass: String
    let predictedConfidence: Float
    
    var text: NSAttributedString {
        return (self.predictedClass + " " + String(format: "%.02f%", self.predictedConfidence * 100))
            .title(.white, weight: .medium)
    }
}
