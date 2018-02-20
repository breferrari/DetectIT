import SpriteKit
import ARKit
import Vision

class Scene: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Cria um anchor com a posição atual da camera
        if let currentFrame = sceneView.session.currentFrame {
            // Executamos o código numa background thread. O que vamos fazer é custoso, então fazer na main thread causaria problemas de performance. :)
            DispatchQueue.global(qos: .background).async {
                do {
                    // Carrega o modelo CoreML desejado
                    let model = try VNCoreMLModel(for: Inceptionv3().model)

                    // Criamos uma request com o modelo desejado
                    let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in

                        // Voltamos pra main thread. Vamos alterar elementos na tela. :)
                        DispatchQueue.main.async {

                            // Acessamos o primeiro resultado na array depois de fazer um cast da array como VNClassificationObservation.
                            // Ele vem como Any?, por isso o cast é necessário.
                            guard let results = request.results as? [VNClassificationObservation],
                                  let result = results.first else {
                                    // Caso não existam resultados, retornamos. Não temos nada pra exibir.
                                    print ("No results?")
                                    return
                            }

                            // Criamos um transform com uma translação de ~0.2 metros a frente da camera
                            var translation = matrix_identity_float4x4
                            translation.columns.3.z = -0.8
                            let transform = simd_mul(currentFrame.camera.transform, translation)

                            // Criamos um novo anchor com essa posição
                            let anchor = ARAnchor(transform: transform)

                            // Definimos um identificador para ele. Com isso temos como saber se ele já existe em outro ponto do código e conseguimos alterá-lo.
                            ARBridge.shared.anchorsToIdentifiers[anchor] = result.identifier

                            // Adicionamos o novo anchor a sessão
                            sceneView.session.add(anchor: anchor)

                        }

                    })

                    // Criamos um handler para a request usando a imagem da camera no momento do toque.
                    let handler = VNImageRequestHandler(cvPixelBuffer: currentFrame.capturedImage, options: [:])
                    // Fazemos o request criado anteriormente com a imagem capturada
                    try handler.perform([request])

                } catch {}
            }
        }
    }

}
