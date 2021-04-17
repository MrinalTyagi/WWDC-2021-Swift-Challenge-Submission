//The following view controller trains the neural network created from scratch in swift. The neural network consists of latest algorithmns including back propagation and L2 regularization. The results and performace of the following trained network can be viewed on the next controller.



import Foundation
import UIKit
import PlaygroundSupport

//MARK: - SpinView

public class SpinnerView : UIView {
    
    public override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }
    
    public override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 4
        setPath()
    }
    
    public override func didMoveToWindow() {
        animate()
    }
    
    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }
    
    
    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }
    
    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7),
            ]
        }
    }
    
    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
        
        animateStrokeHueWithDuration(duration: totalSeconds * 5)
    }
    
    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
    func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        let count = 2
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        animation.values = (1 ..< count).map {
            UIColor(red: CGFloat($0), green: CGFloat($0), blue: CGFloat($0), alpha: 1.0).cgColor
        }
        animation.duration = duration
        animation.calculationMode = .linear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
}



//MARK: - Neural Network View Controller


public class NeuralNetworkViewController : UIViewController, CAAnimationDelegate{
    var epochLabel : UILabel!
    var lossLabel : UILabel!
    var metricsStack : UIStackView!
    var startButton : UIButton!
    var isTraining : Bool = false
    var stopButton : UIButton!
    var spinView : SpinnerView!
    var outputProgress : Array<UIProgressView> = []
    var inputProgress : Array<UIProgressView> = []
    var lossData : Array<Double> = []
    var epochData : Array<Double> = []
    var nextScreenButton : UIButton!
    var disclaimer : UILabel!
    var backButton : UIButton!
    var isTrainingOver : Bool = false
    var layer1Weights : [[Double]]!
    var layer2Weights : [[Double]]!
    var layer1Biases : [Double]!
    var layer2Biases : [Double]!
    public override func viewDidLoad() {
        super.viewDidLoad()
        let cfURL = Bundle.main.url(forResource: "Montserrat-SemiBold", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        
    }
    
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
        
    }
    
    
    fileprivate func setupUI(){
 
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 701, height: 900)
        imageView.image = UIImage(named: "back-no.png")
        self.view.addSubview(imageView)
        

        
        
        let inputStack = UIStackView()
        inputStack.frame = CGRect(x: 116, y: 295.17, width: 48.75, height: 298.79)
        self.view.addSubview(inputStack)
        inputStack.axis = .vertical
        inputStack.spacing = 30.8
        inputStack.distribution = .fillEqually
        var innerLayer : Array<UIView> = []
        for _ in 0...3{
            let neuron = UIView()
            neuron.frame.size = CGSize(width: 48.75, height: 48.75)
            neuron.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
            neuron.clipsToBounds = true
            neuron.layer.cornerRadius = neuron.frame.size.height / 2
            neuron.layer.borderWidth = 5
            neuron.layer.borderColor = UIColor.white.cgColor
            inputStack.addArrangedSubview(neuron)
            
            
            innerLayer.append(neuron)
        }
        
        let hiddenLayer = UIView()
        hiddenLayer.frame = CGRect(x: 329, y: 224, width: 48.75, height: 436)
        self.view.addSubview(hiddenLayer)
        hiddenLayer.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 0.5)
        hiddenLayer.layer.borderWidth = 5
        hiddenLayer.layer.borderColor = UIColor.white.cgColor
        
        let outputStack = UIStackView()
        outputStack.frame = CGRect(x: 534, y: 296.91, width: 48.75, height: 298.79)
        self.view.addSubview(outputStack)
        outputStack.axis = .vertical
        outputStack.spacing = 70.8
        outputStack.distribution = .fillEqually
        var outputLayer : Array<UIView> = []
        for _ in 0...2{
            let neuron = UIView()
            neuron.frame.size = CGSize(width: 48.75, height: 48.75)
            neuron.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
            neuron.clipsToBounds = true
            neuron.layer.cornerRadius = neuron.frame.size.height / 2
            neuron.layer.borderWidth = 5
            neuron.layer.borderColor = UIColor.white.cgColor
            outputStack.addArrangedSubview(neuron)
            outputLayer.append(neuron)
        }
        
        let inputProgressStack = UIStackView()
        inputProgressStack.frame = CGRect(x: 164.75, y: 310.17, width: 164.29, height: 268.79)
        self.view.addSubview(inputProgressStack)
        inputProgressStack.axis = .vertical
        inputProgressStack.distribution = .equalSpacing
        for _ in 0...3{
            let weight = UIProgressView()
            weight.frame.size = CGSize(width: inputProgressStack.frame.size.width, height: 10)
            inputProgress.append(weight)
            inputProgressStack.addArrangedSubview(weight)
        }
        
        
        
        let outputProgressStack = UIStackView()
        outputProgressStack.frame = CGRect(x: 377.75, y: 316.91, width: 157.06, height: 258.79)
        self.view.addSubview(outputProgressStack)
        outputProgressStack.axis = .vertical
        outputProgressStack.distribution = .equalSpacing
        for _ in 0...2{
            let weight = UIProgressView()
            weight.frame.size = CGSize(width: inputProgressStack.frame.size.width, height: 10)
            outputProgress.append(weight)
            outputProgressStack.addArrangedSubview(weight)
        }
        
        
        let headingTitle = UILabel()
        headingTitle.frame = CGRect(x: 50, y: 60, width: self.view.frame.width - 100, height: 50)
        headingTitle.text = "Training"
        headingTitle.font = UIFont(name: "Montserrat-SemiBold", size: 40)
        headingTitle.textColor = UIColor.white
        headingTitle.textAlignment = .center
        self.view.addSubview(headingTitle)
        
        
        //MARK: - Start Training Button
        startButton = UIButton()
        startButton.frame = CGRect(x: 263, y: 700, width: 186, height: 55.27)
        startButton.setTitle("Start Training", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        startButton.clipsToBounds = true
        startButton.layer.cornerRadius = 27.8
        startButton.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
        startButton.titleLabel?.textColor = .white
        self.view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startTraining), for: .touchUpInside)
        
        
        nextScreenButton = UIButton()
        nextScreenButton.frame = CGRect(x: 263, y: 774.27, width: 186, height: 55.27)
        nextScreenButton.setTitle("View Results", for: .normal)
        nextScreenButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        nextScreenButton.clipsToBounds = true
        nextScreenButton.layer.cornerRadius = 27.8
        nextScreenButton.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
        nextScreenButton.titleLabel?.textColor = .white
        self.view.addSubview(nextScreenButton)
        nextScreenButton.addTarget(self, action: #selector(nextScreenShow), for: .touchUpInside)

        disclaimer = UILabel()
        disclaimer.frame = CGRect(x: 0, y: self.view.frame.height - 40, width: self.view.frame.width, height: 30)
        disclaimer.text = "Please complete training first in order to view results."
        disclaimer.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        disclaimer.textColor = .white
        disclaimer.textAlignment = .center
        disclaimer.alpha = 0
        self.view.addSubview(disclaimer)
        
        
        
        metricsStack = UIStackView()
        metricsStack.frame = CGRect(x: 100, y: 130, width: self.view.frame.width - 200, height: 100)
        metricsStack.axis = .horizontal
        metricsStack.distribution = .fillEqually
        self.view.addSubview(metricsStack)
        self.epochLabel = UILabel()
        self.epochLabel.textAlignment = .center
        self.epochLabel.text = "Epoch => --/1000"
        self.epochLabel.textColor = UIColor.white
        self.epochLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.lossLabel = UILabel()
        self.lossLabel.textAlignment = .center
        self.lossLabel.text = "Loss => --"
        self.lossLabel.textColor = .white
        self.lossLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        
        
        metricsStack.addArrangedSubview(epochLabel)
        metricsStack.addArrangedSubview(lossLabel)
        
        spinView = SpinnerView()
        spinView.frame = CGRect(x: 316, y: 713.635, width: 80, height: 80)
        self.view.addSubview(spinView)
        spinView.isHidden = true
        
        
        stopButton = UIButton()
        stopButton.frame = CGRect(x: 326 , y: 723.635, width: 60, height: 60)
        stopButton.setTitle("STOP", for: .normal)
        stopButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        stopButton.clipsToBounds = true
        stopButton.layer.cornerRadius = 27.8
        stopButton.titleLabel?.textColor = UIColor.white
        self.view.addSubview(stopButton)
        stopButton.isEnabled = false
        stopButton.alpha = 0
        stopButton.addTarget(self, action: #selector(stopTraining), for: .touchUpInside)
        
        
        
        
        backButton = UIButton()
        backButton.frame = CGRect(x: 30, y: 30, width: 30, height: 30)
        backButton.setImage(UIImage(named: "backbutton.png"), for: .normal)
        self.view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func nextScreenShow(){
        if isTrainingOver == true{
            let vc = MetricsViewController()
            vc.epoch = epochData
            vc.loss = lossData
            vc.layer1Weights = layer1Weights
            vc.layer2Weights = layer2Weights
            vc.layer1Biases = layer1Biases
            vc.layer2Biases = layer2Biases
            self.presentFullScreen(vc, animated: true, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5) {[self] in
                disclaimer.alpha = 1
            } completion: { (_) in
                
            }

        }

    }
    
    @objc func stopTraining(){
        isTraining = false
        UIView.animate(withDuration: 0.5) { [self] in
            stopButton.alpha = 0
        } completion: { [self] (_) in
            stopButton.isEnabled = false
            spinView.isHidden = true
            startButton.isEnabled = true
            nextScreenButton.isEnabled = true
            UIView.animate(withDuration: 0.5) {
                startButton.alpha = 1
                nextScreenButton.alpha = 1
            }
        }

    }
    
    
    func animateTraining(){
        UIView.animateKeyframes(withDuration: 4.0, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0) { [self] in
                inputProgress[0].setProgress(1.0, animated: true)
                inputProgress[1].setProgress(1.0, animated: true)
                inputProgress[2].setProgress(1.0, animated: true)
                inputProgress[3].setProgress(1.0, animated: true)
            }
            UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 1.0) { [self] in
                outputProgress[0].setProgress(1.0, animated: true)
                outputProgress[1].setProgress(1.0, animated: true)
                outputProgress[2].setProgress(1.0, animated: true)
            }
            UIView.addKeyframe(withRelativeStartTime: 2.0, relativeDuration: 1.0) { [self] in
                outputProgress[0].setProgress(1.0, animated: true)
                outputProgress[1].setProgress(1.0, animated: true)
                outputProgress[2].setProgress(1.0, animated: true)
            }
            UIView.addKeyframe(withRelativeStartTime: 3.0, relativeDuration: 1.0) { [self] in
                inputProgress[0].setProgress(0.0, animated: true)
                inputProgress[1].setProgress(0.0, animated: true)
                inputProgress[2].setProgress(0.0, animated: true)
                inputProgress[3].setProgress(0.0, animated: true)
            }
        } completion: { (_) in

        }
    }
    
    @objc func inputDataIn(){
        UIView.animate(withDuration: 1.0) { [self] in
            inputProgress[0].setProgress(1.0, animated: true)
            inputProgress[1].setProgress(1.0, animated: true)
            inputProgress[2].setProgress(1.0, animated: true)
            inputProgress[3].setProgress(1.0, animated: true)
        } completion: { [self] (_) in
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(outputDataIn), userInfo: nil, repeats: false)
        }
    }
    
    @objc func outputDataIn(){
        UIView.animate(withDuration: 1.0) { [self] in
            outputProgress[0].setProgress(1.0, animated: true)
            outputProgress[1].setProgress(1.0, animated: true)
            outputProgress[2].setProgress(1.0, animated: true)
        } completion: { [self] (_) in
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(outputDataOut), userInfo: nil, repeats: false)
        }

    }
    
    @objc func outputDataOut(){
        UIView.animate(withDuration: 1.0) { [self] in
            outputProgress[0].setProgress(0.0, animated: true)
            outputProgress[1].setProgress(0.0, animated: true)
            outputProgress[2].setProgress(0.0, animated: true)
        } completion: { (finished : Bool) in

        }
        
    }
    
    @objc func inputDataOut(){
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut) { [self] in
            inputProgress[0].setProgress(0.0, animated: true)
            inputProgress[1].setProgress(0.0, animated: true)
            inputProgress[2].setProgress(0.0, animated: true)
            inputProgress[3].setProgress(0.0, animated: true)
        } completion: { (finished : Bool) in
            
        }
    }
    
    func trainingOver(){
        if isTrainingOver{
            UIView.animate(withDuration: 0.5) {[self] in
                spinView.alpha = 0
                stopButton.alpha = 0
            } completion: { [self](_) in
                spinView.isHidden = true
                stopButton.isHidden = true
                UIView.animate(withDuration: 0.5) {[self] in
                    startButton.alpha = 1
                    nextScreenButton.alpha = 1
                } completion: { (_) in
                    startButton.isEnabled = true
                    nextScreenButton.isEnabled = true
                }

            }

        }
    }
    
    

    @objc func startTraining(){
        isTraining = true
        UIView.animate(withDuration: 0.5) { [self] in
            startButton.alpha = 0
            nextScreenButton.alpha = 0
        } completion: { [self] (_) in
            startButton.isEnabled = false
            nextScreenButton.isEnabled = true
            stopButton.isEnabled = true
            UIView.animate(withDuration: 0.5) {
                spinView.isHidden = false
                stopButton.alpha = 1
            } completion: { (_) in
            }

        }
        var data = parseCSV()
        data.removeFirst()
        var X : Array<Array<Double>> = [[]]
        var Y : [String] = []
        for i in data{
            let label = i.4
            Y.append(label)
            let (first, second, third, fourth) = (Double(i.0), Double(i.1), Double(i.2), Double(i.3))
            var row : Array<Double> = []
            row.append(first!)
            row.append(second!)
            row.append(third!)
            row.append(fourth!)
            if row.count != 0{
                X.append(row)
            }
        }
        X.removeFirst()
        var Y_reformed : Array<Array<Double>> = Array.init(repeating: Array.init(repeating: 0.0, count: 3), count: Y.count)
        for i in 0..<Y.count{
            if Y[i] == "Setosa"{
                Y_reformed[i][0] = 1.0
            }else if Y[i] == "Versicolor"{
                Y_reformed[i][1] = 1.0
            }else if Y[i] == "Virginica"{
                Y_reformed[i][2] = 1.0
            }
        }
        
        let hidden_nodes = 5
        let num_labels = 3
        let num_features = 4
        let learning_rate = 0.004
        let regLambda = 0.01
        
        layer1Weights = Array.init(repeating: Array.init(repeating: 0.0, count: hidden_nodes), count: num_features)
        layer2Weights = Array.init(repeating: Array.init(repeating: 0.0, count: num_labels), count: hidden_nodes)
        for i in 0..<num_features{
            for j in 0..<hidden_nodes{
                layer1Weights[i][j] = Double.random(in: -1...1)
            }
        }
        
        for i in 0..<hidden_nodes{
            for j in 0..<num_labels{
                layer2Weights[i][j] = Double.random(in: -1...1)
            }
        }
        
        layer1Biases = Array.init(repeating: 0.0, count: hidden_nodes)
        layer2Biases = Array.init(repeating: 0.0, count: num_labels)
        
        DispatchQueue.global(qos: .background).async { [self] in
            for epoch in 0...1000{
                if isTraining == false{
                    break
                }
                let inputLayer = X.dot(layer1Weights)
                let hiddenLayer = reluActivation(input: (inputLayer?.add(layer1Biases))!)
                let outputLayer = hiddenLayer.dot(layer2Weights)?.add(layer2Biases)
                let outputProbs = softmax(outputArray: outputLayer!)
                var loss = crossEntropySoftmaxLossArray(softmaxProbabilities: outputProbs, Y: Y_reformed)
                loss += regularizationL2SoftmaxLoss(regLambda: regLambda, weight1: layer1Weights, weight2: layer2Weights)
                var outputErrorSignal = outputProbs.sub(Y_reformed)
                for i in 0..<outputErrorSignal!.count{
                    outputErrorSignal![i] = outputErrorSignal![i].div(Double(outputProbs.count))
                }
                var errorSignalHidden = outputErrorSignal?.dot(layer2Weights.T)
                for i in 0..<hiddenLayer.count{
                    for j in 0..<hiddenLayer[0].count{
                        if hiddenLayer[i][j] <= 0{
                            errorSignalHidden![i][j] = 0
                        }
                    }
                }
                let gradientLayer2Weights = hiddenLayer.T.dot(outputErrorSignal!)
                var inter2 : [Double] = []
                for i in 0..<outputErrorSignal!.count{
                    inter2.append(outputErrorSignal![i].reduce(0, +))
                }
                let gradientLayer2Bias : Double = inter2.reduce(0, +)
                let gradientLayer1Weights = X.T.dot(errorSignalHidden!)
                var inter : [Double] = []
                for i in 0..<errorSignalHidden!.count{
                    inter.append(errorSignalHidden![i].reduce(0, +))
                }
                let gradientLayer1Bias : Double = inter.reduce(0, +)
                layer1Weights = layer1Weights.sub((gradientLayer1Weights?.mul(learning_rate))!)!
                let mul1 = gradientLayer1Bias * learning_rate
                for i in 0..<layer1Biases.count{
                    layer1Biases[i] = layer1Biases[i] - mul1
                }
                layer2Weights = layer2Weights.sub((gradientLayer2Weights?.mul(learning_rate))!)!
                let mul2 = gradientLayer2Bias * learning_rate
                for i in 0..<layer2Biases.count{
                    layer2Biases[i] = layer2Biases[i] - mul2
                }
                epochData.append(Double(epoch))
                lossData.append(Double(loss * 100))
                
                if epoch % 1 == 0{
                    DispatchQueue.main.async {
                        self.epochLabel.text = "Epoch => \(epoch)/1000"
                        self.lossLabel.text = "Loss => \(String.init(format: "%.3f", loss))"
                    }
                }
                if epoch % 100 == 0{
                    DispatchQueue.main.async {
                        self.inputDataIn()
                    }
                }
                if epoch == 1000{
                    isTrainingOver = true
                    trainingOver()
                }
            }
        }
        
        
    }
    
    //MARK: - Helper Functions
    
    func reluActivation(input : [[Double]]) -> [[Double]]{
        var output = Array.init(repeating: Array.init(repeating: 0.0, count: input[0].count), count: input.count)
        for i in 0..<input.count{
            for j in 0..<input[0].count{
                if input[i][j] > 0{
                    output[i][j] = input[i][j]
                }else{
                    output[i][j] = 0
                }
            }
        }
        return output
    }
    
    func softmax(outputArray : [[Double]]) -> [[Double]]{
        var logits_exps = Array.init(repeating: Array.init(repeating: 0.0, count: outputArray[0].count), count: outputArray.count)
        for i in 0..<outputArray.count{
            for j in 0..<outputArray[0].count{
                logits_exps[i][j] = exp(outputArray[i][j])
            }
        }
        var sum = Array.init(repeating: 0.0, count: outputArray.count)
        for i in 0..<logits_exps.count{
            sum[i] = logits_exps[i].reduce(0, +)
        }
        for i in 0..<logits_exps.count{
            logits_exps[i] = logits_exps[i].div(sum[i])
        }
        return logits_exps
    }
    
    func regularizationL2SoftmaxLoss(regLambda : Double, weight1 : [[Double]], weight2 : [[Double]]) -> Double{
        let weights1Loss = 0.5 * regLambda * (weight1.elmul(weight1)?.sum())!
        let weight2Loss = 0.5 * regLambda * (weight2.elmul(weight2)?.sum())!
        return weights1Loss + weight2Loss
    }

    
    func crossEntropySoftmaxLossArray(softmaxProbabilities : [[Double]], Y : [[Double]]) -> Double{
        var indices : [Int] = []
        for i in 0..<Y.count{
            for j in 0..<Y[0].count{
                if Y[i][j] == 1.0{
                    indices.append(j)
                }
            }
        }
        var probabilities : [Double] = []
        for i in 0..<softmaxProbabilities.count{
            probabilities.append(softmaxProbabilities[i][indices[i]])
        }
        var log_pred : [Double] = Array.init(repeating: 0.0, count: probabilities.count)
        for i in 0..<probabilities.count{
            log_pred[i] = log(probabilities[i])
        }
        let loss = -1 * log_pred.reduce(0, +) / Double(log_pred.count)
        return loss
        
    }
    
    func openCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
        else {
            return nil
        }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func parseCSV() -> [(String, String, String, String, String)]{
        
        let dataString: String! = openCSV(fileName: "iris", fileType: "csv")
        var items: [(String, String, String, String, String)] = []
        let lines: [String] = dataString.components(separatedBy: NSCharacterSet.newlines) as [String]
        
        for line in lines {
            var values: [String] = []
            if line != "" {
                if line.range(of: "\"") != nil {
                    var textToScan:String = line
                    var value:String?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while !textScanner.isAtEnd {
                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            
                            
                            textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                            
                            value = textScanner.scanUpToString("\"")
                            textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                        } else {
                            value = textScanner.scanUpToString(",")
                        }
                        
                        values.append(value! as String)
                        
                        if !textScanner.isAtEnd{
                            let indexPlusOne = textScanner.string.index(after: textScanner.currentIndex)
                            
                            textToScan = String(textScanner.string[indexPlusOne...])
                        } else {
                            textToScan = ""
                        }
                        textScanner = Scanner(string: textToScan)
                    }
                    
                } else  {
                    values = line.components(separatedBy: ",")
                }
                let item = (values[0], values[1], values[2], values[3], values[4])
                items.append(item)
            }
        }
        return items
    }
}


