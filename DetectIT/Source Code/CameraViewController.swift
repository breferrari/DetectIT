import UIKit
import SceneKit
import ARKit
import Vision

class CameraViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak private var sceneView: ARSCNView!

    // MARK: Properties

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

    // MARK: Configuration

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

}

// MARK: SceneView Delegate

extension CameraViewController: ARSCNViewDelegate {

}
