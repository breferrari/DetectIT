import UIKit
import SceneKit
import ARKit

class SceneViewController: UIViewController {

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

extension SceneViewController: ARSKViewDelegate {

    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Verifica se anchor está registrado
        guard let identifier = ARBridge.shared.anchorsToIdentifiers[anchor] else {
            return nil
        }

        // Caso positivo, cria um SKLabelNode, que é a label que será exibida no ponto do anchor.
        let labelNode = SKLabelNode(text: identifier)
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.fontName = UIFont.boldSystemFont(ofSize: 13).fontName
        return labelNode
    }

}
