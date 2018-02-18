import UIKit
import SceneKit
import ARKit
import Vision

class CameraViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak private var sceneView: ARSCNView!

    // MARK: Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private var bounds: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSceneView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseSession()
    }

    // MARK: SceneView Configuration

    private func configureSceneView() {
        // Define delegate
        sceneView.delegate = self

        // autoenablesDefaultLighting tem como default (false)
        // Essa propriedade quando (true) adiciona luz omnidirecional
        // quando renderizando scenes que não contenham luminosidade
        sceneView.autoenablesDefaultLighting = true

        // Guarda os bounds da sceneView TODO: (?)
        bounds = sceneView.bounds
    }

    private func configureSession() {
        // Cria configuração da sessão
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }

    private func pauseSession() {
        // Pausa sessão para não ficar rodando em background
        sceneView.session.pause()
    }

}

// MARK: SceneView Delegate

extension CameraViewController: ARSCNViewDelegate {

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .limited(.initializing):
            print("[sceneView] Initializing...")
        case .notAvailable:
            print("[sceneView] Not available.")
        default:
            print("[sceneView] Initialized.")
        }
    }

}
