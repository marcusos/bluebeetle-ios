import AVFoundation
import UIKit

final class CameraDevice {
    weak var delegate: AVCaptureVideoDataOutputSampleBufferDelegate? {
        didSet {
            self.captureDataOutput.setSampleBufferDelegate(self.delegate, queue: self.queue)
        }
    }
    
    private let queue = DispatchQueue(label: "me.hittag.Camera", qos: .userInteractive)
    private let captureDevice: AVCaptureDevice
    private let captureSession: AVCaptureSession
    private let captureDataOutput: AVCaptureVideoDataOutput
    private let videoPreviewLayer: AVCaptureVideoPreviewLayer
    
    var layer: CALayer {
        return self.videoPreviewLayer
    }
    
    init(captureDevice device: AVCaptureDevice?) throws {
        guard let captureDevice = device, let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            throw CameraDeviceInitializationError.unsupportedCaptureDevice(device)
        }
        
        let captureDataOutput = AVCaptureVideoDataOutput()
        let captureSession = AVCaptureSession()
        captureSession.addInput(input)
        captureSession.addOutput(captureDataOutput)
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        self.captureDevice = captureDevice
        self.captureSession = captureSession
        self.captureDataOutput = captureDataOutput
        self.videoPreviewLayer = videoPreviewLayer
    }
    
    func set(frame: CGRect) {
        self.videoPreviewLayer.frame = frame
    }
    
    func startRunning() {
        self.captureSession.startRunning()
    }
}
