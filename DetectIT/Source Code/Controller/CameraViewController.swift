import UIKit
import SceneKit
import ARKit

class CameraViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak private var sceneView: ARSKView!

    // MARK: Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

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

        // Mostra estatísticas
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true

        let scene = Scene(size: self.view.frame.size)
        sceneView.presentScene(scene)
    }

    private func configureSession() {
        // Cria configuração da sessão
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    private func pauseSession() {
        // Pausa sessão para não ficar rodando em background
        sceneView.session.pause()
    }

}

// MARK: ARSKViewDelegate

extension CameraViewController: ARSKViewDelegate {

    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Verifica se anchor está registrado
        guard let identifier = ARBridge.shared.anchorsToIdentifiers[anchor] else {
            return nil
        }

        // Caso positivo, cria um label para exibir no node e retorna o node a ser exibido
        let labelNode = SKLabelNode(text: identifier)
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.fontName = UIFont.boldSystemFont(ofSize: 13).fontName
        return labelNode
    }

}
