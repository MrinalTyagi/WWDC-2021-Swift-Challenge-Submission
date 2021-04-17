//The following view controller explains and showcases the epoch versus loss graph of the neural network trained in previous controller. The results will vary everytime as the weights in the view controller are initialised randomly and are different everytime. 



import Foundation
import UIKit

public class MetricsViewController : UIViewController{
    var epoch : Array<Double>!
    var loss : Array<Double>!
    var dataPoints : Array<CGPoint> = []
    var bottomView : UIView!
    var textLabel : UILabel!
    var backButton : UIButton!
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
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    
    func setupUI(){
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 701, height: 900)
        imageView.image = UIImage(named: "back-no.png")
        self.view.addSubview(imageView)
        
        
        let headingTitle = UILabel()
        headingTitle.text = "Results"
        headingTitle.font = UIFont(name: "Montserrat-SemiBold", size: 40)
        headingTitle.textColor = UIColor.white
        headingTitle.textAlignment = .center
        self.view.addSubview(headingTitle)
        headingTitle.translatesAutoresizingMaskIntoConstraints = false
        headingTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        headingTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        headingTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headingTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        

        let graphView = UIView()
        graphView.frame = CGRect(x: 150, y: 150, width: 400, height: 400)
        graphView.clipsToBounds = true
        graphView.layer.cornerRadius = 20
        self.view.addSubview(graphView)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        graphView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        graphView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        graphView.topAnchor.constraint(equalTo: headingTitle.bottomAnchor, constant: 40).isActive = true
        graphView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        let maxLoss = loss.max()
        let minLoss = loss.min()
        let minEpoch = epoch.min()
        let maxEpoch = epoch.max()
        for i in 0..<epoch.count{
            let x = ((epoch[i] - minEpoch!) / (maxEpoch! - minEpoch!)) * 300
            let y = ((maxLoss! - loss[i]) / (maxLoss! - minLoss!)) * 300
            dataPoints.append(CGPoint(x: x, y: y))
        }
        let path = UIBezierPath()
        path.move(to: dataPoints[0])
        for i in 1..<dataPoints.count{
            path.addLine(to: dataPoints[i])
        }
        let shape = CAShapeLayer()
        shape.frame = CGRect(x: 50, y: 50, width: 300, height: 300)
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 4
        shape.path = path.cgPath
        graphView.layer.addSublayer(shape)
        
        let xLabel = UILabel()
        xLabel.text = "Number of Epochs"
        xLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        xLabel.textAlignment = .center
        xLabel.textColor = .white
        self.view.addSubview(xLabel)
        xLabel.translatesAutoresizingMaskIntoConstraints = false
        xLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 20).isActive = true
        xLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        xLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        xLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        let yLabel = UILabel()
        yLabel.text = "Loss"
        yLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        yLabel.textAlignment = .right
        yLabel.textColor = .white
        self.view.addSubview(yLabel)
        yLabel.translatesAutoresizingMaskIntoConstraints = false
        yLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        yLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        yLabel.rightAnchor.constraint(equalTo: graphView.leftAnchor, constant: -20).isActive = true
        yLabel.centerYAnchor.constraint(equalTo: graphView.centerYAnchor).isActive = true
        
        
        bottomView = UIView()
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 20
        bottomView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        self.view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        bottomView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 100).isActive = true
        
        self.textLabel = UILabel()
        self.bottomView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
        textLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 30).isActive = true
        textLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -30).isActive = true
        textLabel.text = "The following graph represents the loss per epoch. It can be clearly seen that as number of epoch increases, the loss decreases, but not in an abrupt manner due to presence of L2 regularization during training."
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        textLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        //MARK: - Prediction Screen Button
        let nextScreenButton = UIButton()
        nextScreenButton.frame = CGRect(x: 263, y: 800, width: 186, height: 55.27)
        nextScreenButton.setTitle("Predict", for: .normal)
        nextScreenButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        nextScreenButton.titleLabel?.textColor = UIColor.white
        nextScreenButton.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
        nextScreenButton.clipsToBounds = true
        nextScreenButton.layer.cornerRadius = 27.8
        self.view.addSubview(nextScreenButton)
        nextScreenButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        
        
        backButton = UIButton()
        backButton.frame = CGRect(x: 30, y: 30, width: 30, height: 30)
        backButton.setImage(UIImage(named: "backbutton.png"), for: .normal)
        self.view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func nextScreen(){
        let vc = PredictViewController()
        vc.layer1Weights = layer1Weights
        vc.layer2Weights = layer2Weights
        vc.layer1Biases = layer1Biases
        vc.layer2Biases = layer2Biases
        self.presentFullScreen(vc, animated: true, completion: nil)
    }
    
}

