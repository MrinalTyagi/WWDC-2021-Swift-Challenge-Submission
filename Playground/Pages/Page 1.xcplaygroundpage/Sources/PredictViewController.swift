//The following view controller uses the same weights from the neural network trained earlier and uses them to predict the class of the iris inputed by the user. If user does not inputs anything then it will give them a warning in order to input something.



import Foundation
import UIKit
import PlaygroundSupport

public class PredictViewController : UIViewController{
    
    var predictButton : UIButton!
    var backButton : UIButton!
    var predictionLabel : UILabel!
    var sepalLength : CustomTextField!
    var sepalWidth : CustomTextField!
    var petalLength : CustomTextField!
    var petalWidth : CustomTextField!
    var layer1Weights : [[Double]]!
    var layer2Weights : [[Double]]!
    var layer1Biases : [Double]!
    var layer2Biases : [Double]!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let cfURL = Bundle.main.url(forResource: "Montserrat-SemiBold", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        setupUI()
    }
    
    
    func setupUI(){
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 701, height: 900)
        imageView.image = UIImage(named: "back.png")
        self.view.addSubview(imageView)
        
        
        let headingTitle = UILabel()
        headingTitle.text = "Prediction"
        headingTitle.font = UIFont(name: "Montserrat-SemiBold", size: 40)
        headingTitle.textColor = UIColor.white
        headingTitle.textAlignment = .center
        self.view.addSubview(headingTitle)
        headingTitle.translatesAutoresizingMaskIntoConstraints = false
        headingTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        headingTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        headingTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headingTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        
        let stack1 = UIStackView()
        stack1.axis = .horizontal
        stack1.distribution = .fillEqually
        stack1.spacing = 20
        sepalLength = CustomTextField(text: "Input Sepal Length")
        sepalWidth = CustomTextField(text: "Input Sepal Width")
        stack1.addArrangedSubview(sepalLength)
        stack1.addArrangedSubview(sepalWidth)
        
        let stack2 = UIStackView()
        stack2.axis = .horizontal
        stack2.distribution = .fillEqually
        stack2.spacing = 20
        petalLength = CustomTextField(text: "Input Petal Length")
        petalWidth = CustomTextField(text: "Input Petal Width")
        stack2.addArrangedSubview(petalLength)
        stack2.addArrangedSubview(petalWidth)
        
        let stackMain = UIStackView()
        stackMain.axis = .vertical
        stackMain.distribution = .fillEqually
        stackMain.spacing = 30
        self.view.addSubview(stackMain)
        stackMain.translatesAutoresizingMaskIntoConstraints = false
        stackMain.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        stackMain.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        stackMain.topAnchor.constraint(equalTo: headingTitle.bottomAnchor, constant: 50).isActive = true
        stackMain.heightAnchor.constraint(equalToConstant: 120).isActive = true

        
        stackMain.addArrangedSubview(stack1)
        stackMain.addArrangedSubview(stack2)
        
        predictButton = UIButton()
        predictButton.setTitle("Predict", for: .normal)
        predictButton.titleLabel?.textColor = UIColor.white
        predictButton.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
        predictButton.clipsToBounds = true
        predictButton.layer.cornerRadius = 27.8
        predictButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        self.view.addSubview(predictButton)
        predictButton.translatesAutoresizingMaskIntoConstraints = false
        predictButton.topAnchor.constraint(equalTo: stackMain.bottomAnchor, constant: 30).isActive = true
        predictButton.widthAnchor.constraint(equalToConstant: 186).isActive = true
        predictButton.heightAnchor.constraint(equalToConstant: 55.27).isActive = true
        predictButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        predictButton.addTarget(self, action: #selector(predict), for: .touchUpInside)
        
        
        
        let imageStack = UIStackView()
        imageStack.axis = .horizontal
        imageStack.distribution = .fillEqually
        imageStack.spacing = 20
        self.view.addSubview(imageStack)
        imageStack.translatesAutoresizingMaskIntoConstraints = false
        imageStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        imageStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        imageStack.topAnchor.constraint(equalTo: predictButton.bottomAnchor, constant: 60).isActive = true
        imageStack.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        let setosa = UIImageView()
        setosa.clipsToBounds = true
        setosa.layer.cornerRadius = 20
        setosa.contentMode = .scaleAspectFit
        setosa.image = UIImage(named: "setosa.jpeg")
        imageStack.addArrangedSubview(setosa)
        
        let versicolor = UIImageView()
        versicolor.clipsToBounds = true
        versicolor.layer.cornerRadius = 20
        versicolor.contentMode = .scaleAspectFit
        versicolor.image = UIImage(named: "versicolor.jpg")
        imageStack.addArrangedSubview(versicolor)
        
        let virginica = UIImageView()
        virginica.clipsToBounds = true
        virginica.layer.cornerRadius = 20
        virginica.contentMode = .scaleAspectFit
        virginica.image = UIImage(named: "virginica.jpg")
        imageStack.addArrangedSubview(virginica)
        
        
        
        backButton = UIButton()
        backButton.frame = CGRect(x: 30, y: 30, width: 30, height: 30)
        backButton.setImage(UIImage(named: "backbutton.png"), for: .normal)
        self.view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        
        let textStack = UIStackView()
        textStack.axis = .horizontal
        textStack.distribution = .fillEqually
        textStack.spacing = 20
        self.view.addSubview(textStack)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        textStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        textStack.topAnchor.constraint(equalTo: imageStack.bottomAnchor, constant: 30).isActive = true
        textStack.heightAnchor.constraint(equalToConstant: 20).isActive = true

        
        
        let setosaLabel = UILabel()
        setosaLabel.text = "Iris Setosa"
        setosaLabel.textAlignment = .center
        setosaLabel.textColor = .white
        setosaLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        let versicolorLabel = UILabel()
        versicolorLabel.text = "Iris Versicolor"
        versicolorLabel.textAlignment = .center
        versicolorLabel.textColor = .white
        versicolorLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        let virginicalLabel = UILabel()
        virginicalLabel.text = "Iris Virginica"
        virginicalLabel.textAlignment = .center
        virginicalLabel.textColor = .white
        virginicalLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        textStack.addArrangedSubview(setosaLabel)
        textStack.addArrangedSubview(versicolorLabel)
        textStack.addArrangedSubview(virginicalLabel)
        
        
        predictionLabel = UILabel()
        predictionLabel.text = "Predicted class is : "
        predictionLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        predictionLabel.textColor = .white
        predictionLabel.textAlignment = .center
        self.view.addSubview(predictionLabel)
        predictionLabel.translatesAutoresizingMaskIntoConstraints = false
        predictionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        predictionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        predictionLabel.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 80).isActive = true
        predictionLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        predictionLabel.alpha = 0
        predictionLabel.isEnabled = false
        
        
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func predict(){
        self.view.endEditing(true)
        if let sepalLength = sepalLength.textField.text, let sepalWidth = sepalWidth.textField.text, let petalLength = petalLength.textField.text, let petalWidth = petalWidth.textField.text{
            if let sepalLengthDouble = Double(sepalLength), let sepalWidthDouble = Double(sepalWidth), let petalWidthDouble = Double(petalWidth), let petalLengthDouble = Double(petalLength){
                let inputs : [[Double]] = [[sepalLengthDouble, sepalWidthDouble, petalLengthDouble, petalWidthDouble]]
                let inputLayer = inputs.dot(layer1Weights)
                let sum = inputLayer!.add(layer1Biases)
                let hiddenLayer = reluActivation(input: sum!)
                let inter = hiddenLayer.dot(layer2Weights)
                let sum2 = inter!.add(layer2Biases)
                let probs = softmax(outputArray: sum2!)[0]
                let max = probs.max()
                var predictionClass : String = ""
                if probs[0] == max{
                    predictionClass = "Iris Setosa"
                }else if probs[1] == max{
                    predictionClass = "Iris Versicolor"
                }else if probs[2] == max{
                    predictionClass = "Iris Virginica"
                }
                DispatchQueue.main.async {[self] in 
                    predictionLabel.text = "Predicted class is : \(predictionClass)"
                    predictionLabel.isEnabled = true
                    UIView.animate(withDuration: 0.5) {[self] in
                        predictionLabel.alpha = 1
                    } completion: { (_) in
                        
                    }
                }
            }
            else{
                let disclaimer = UILabel()
                disclaimer.text = "Please input valid Double values."
                disclaimer.textColor = .white
                disclaimer.textAlignment = .center
                disclaimer.font = UIFont(name: "Montserrat-SemiBold", size: 20)
                self.view.addSubview(disclaimer)
                disclaimer.translatesAutoresizingMaskIntoConstraints = false
                disclaimer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
                disclaimer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
                disclaimer.heightAnchor.constraint(equalToConstant: 30).isActive = true
                disclaimer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
                UIView.animateKeyframes(withDuration: 0.5, delay: 5) {
                    disclaimer.alpha = 0
                } completion: { (_) in
                    disclaimer.isEnabled = false
                }

            }
        }else{
            let disclaimer = UILabel()
            disclaimer.text = "Values should not be nill in order to predict class."
            disclaimer.textColor = .white
            disclaimer.textAlignment = .center
            disclaimer.font = UIFont(name: "Montserrat-SemiBold", size: 20)
            self.view.addSubview(disclaimer)
            disclaimer.translatesAutoresizingMaskIntoConstraints = false
            disclaimer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
            disclaimer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
            disclaimer.heightAnchor.constraint(equalToConstant: 30).isActive = true
            disclaimer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
            UIView.animateKeyframes(withDuration: 0.5, delay: 5) {
                disclaimer.alpha = 0
            } completion: { (_) in
                disclaimer.isEnabled = false
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
    
    
    
}



class CustomTextField : UIView{
    var text : String!
    var textField : UITextField!
    convenience init(text : String){
        self.init()
        self.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        setupView()
        
    }
    
    func setupView(){
        textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = text
        textField.backgroundColor = .clear
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    }
}
