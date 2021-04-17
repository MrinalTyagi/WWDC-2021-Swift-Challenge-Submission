//The following view controller is the entry view controller to the program that will be training a neural network from scratch in swift and then predicting results using inputs provided by the user.


import Foundation
import UIKit
import PlaygroundSupport


public class GettingStartedViewController : UIViewController{
    
    public override func viewDidLoad() {
        setupView()
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    fileprivate func setupView(){
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: 701, height: 900)
        imgView.image = UIImage(named: "back.png")
        self.view.addSubview(imgView)
        
        let cfURL = Bundle.main.url(forResource: "Montserrat-SemiBold", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)

        
        
        let label = UILabel()
        label.text = "Interactive Playground to Demonstrate about the Working of Neural Networks"
        label.font = UIFont(name: "Montserrat-SemiBold", size: 32)
        label.frame = CGRect(x: 53, y: 67, width: 531, height: 130)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        
        let cardView = UIView()
        cardView.frame = CGRect(x: 41, y: 227, width: 379, height: 467)

        //MARK: - First Card
        let firstCard = UIView()
        firstCard.frame = CGRect(x: 54, y: 54, width: 270, height: 380)
        firstCard.backgroundColor = UIColor(red: 12/255, green: 159/255, blue: 179/255, alpha: 1.0)
        firstCard.clipsToBounds = true
        firstCard.layer.cornerRadius = 12
        cardView.addSubview(firstCard)
        
        let firstFirst = UIView()
        firstFirst.frame = CGRect(x: 13.36, y: 28, width: 244.6, height: 110)
        firstFirst.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.21)
        firstFirst.clipsToBounds = true
        firstFirst.layer.cornerRadius = 8
        firstCard.addSubview(firstFirst)
    
        let firstSecond = UIView()
        firstSecond.frame = CGRect(x: 13.36, y: 149, width: 244.6, height: 46.22)
        firstSecond.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.21)
        firstSecond.clipsToBounds = true
        firstSecond.layer.cornerRadius = 8
        firstCard.addSubview(firstSecond)
        
        let firstThird = UIView()
        firstThird.frame = CGRect(x: 13.36, y: 209, width: 244.6, height: 46.22)
        firstThird.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.21)
        firstThird.clipsToBounds = true
        firstThird.layer.cornerRadius = 8
        firstCard.addSubview(firstThird)
        
        let firstFourth = UIView()
        firstFourth.frame = CGRect(x: 13.36, y: 270, width: 244.6, height: 46.22)
        firstFourth.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.21)
        firstFourth.clipsToBounds = true
        firstFourth.layer.cornerRadius = 8
        firstCard.addSubview(firstFourth)
        
        
        
        //MARK: - Second Card
        let secondCard = UIView()
        secondCard.frame = CGRect(x: 0, y: 325, width: 139, height: 141)
        secondCard.backgroundColor = UIColor(red: 9/255, green: 86/255, blue: 110/255, alpha: 1.0)
        secondCard.clipsToBounds = true
        secondCard.layer.cornerRadius = 12
        cardView.addSubview(secondCard)
        
        let secondFirst = UIView()
        secondFirst.frame = CGRect(x: 13, y: 15.19, width: 41.42, height: 43.75)
        secondFirst.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.26)
        secondFirst.clipsToBounds = true
        secondFirst.layer.cornerRadius = 3
        secondCard.addSubview(secondFirst)
        
        let secondSecond = UIView()
        secondSecond.frame = CGRect(x: 59.57, y: 15.19, width: 41.42, height: 43.75)
        secondSecond.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.12)
        secondSecond.clipsToBounds = true
        secondSecond.layer.cornerRadius = 3
        secondCard.addSubview(secondSecond)
        
        let secondThird = UIView()
        secondThird.frame = CGRect(x: 13, y: 69.13, width: 111.2, height: 5.39)
        secondThird.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        secondCard.addSubview(secondThird)
        
        let secondFourth = UIView()
        secondFourth.frame = CGRect(x: 13, y: 82.31, width: 111.2, height: 5.39)
        secondFourth.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.78)
        secondCard.addSubview(secondFourth)
        
        let secondFifth = UIView()
        secondFifth.frame = CGRect(x: 13, y: 95.5, width: 111.2, height: 5.39)
        secondFifth.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.60)
        secondCard.addSubview(secondFifth)
        
        let secondSixth = UIView()
        secondSixth.frame = CGRect(x: 13, y: 108.68, width: 84.54, height: 5.39)
        secondSixth.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.44)
        secondCard.addSubview(secondSixth)
        
        
        
        //MARK: - Third Card
        let thirdCard = UIView()
        thirdCard.frame = CGRect(x: 215, y: 0, width: 162, height: 217)
        thirdCard.backgroundColor = UIColor(red: 216/255, green: 233/255, blue: 243/255, alpha: 1.0)
        thirdCard.clipsToBounds = true
        thirdCard.layer.cornerRadius = 12
        cardView.addSubview(thirdCard)
        
        let thirdFirst = UIView()
        thirdFirst.frame = CGRect(x: 9.02, y: 11.16, width: 143.77, height: 129.9)
        thirdFirst.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        thirdFirst.clipsToBounds = true
        thirdFirst.layer.cornerRadius = 6
        thirdCard.addSubview(thirdFirst)
        
        let thirdSecond = UIView()
        thirdSecond.frame = CGRect(x: 9.02, y: 149.8, width: 143.77, height: 9.56)
        thirdSecond.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        thirdCard.addSubview(thirdSecond)
        
        let thirdThird = UIView()
        thirdThird.frame = CGRect(x: 9.02, y: 166.56, width: 143.77, height: 9.56)
        thirdThird.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.69)
        thirdCard.addSubview(thirdThird)
        
        let thirdFourth = UIView()
        thirdFourth.frame = CGRect(x: 9.02, y: 183.29, width: 96.11, height: 9.56)
        thirdFourth.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.41)
        thirdCard.addSubview(thirdFourth)
        

        self.view.addSubview(cardView)
        
        
        //MARK: - Getting Started Button
        let startButton = UIButton()
        startButton.frame = CGRect(x: 64, y: 781, width: 186, height: 55.27)
        startButton.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
        startButton.setTitle("GET STARTED", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        startButton.titleLabel?.textColor = UIColor.white
        startButton.clipsToBounds = true
        startButton.layer.cornerRadius = 27.64
        self.view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        
        
        
        
        //MARK: - Dashed Lines
        let dashedLineHorizontal = UIView()
        dashedLineHorizontal.frame = CGRect(x: 33.84, y: 67.56, width: 292.00, height: 5)
        drawDottedLine(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 291.05, y: 0), view: dashedLineHorizontal)
        cardView.addSubview(dashedLineHorizontal)
        
        let dashedLineVertical = UIView()
        dashedLineVertical.frame = CGRect(x: 33.84, y: 67.56, width: 257.68, height: 5)
        drawDottedLine(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 257.68), view: dashedLineVertical)
        cardView.addSubview(dashedLineVertical)
        
//        Vertical Dots
        for i in 0...5{
            let dot = UIView()
            dot.frame = CGRect(x: 27.75, y: 61.79 + Double(i) * 50.0, width: 11.54, height: 11.54)
            dot.clipsToBounds = true
            dot.layer.cornerRadius = dot.layer.frame.size.height / 2
            dot.backgroundColor = UIColor.white
            cardView.addSubview(dot)
        }
        
//        Horizontal Dots
        for i in 0...3{
            let dot = UIView()
            dot.frame = CGRect(x: 27.75 + Double(i + 1) * 50.0 , y: 63.00, width: 8.54, height: 8.54)
            dot.clipsToBounds = true
            dot.layer.cornerRadius = dot.layer.frame.size.height / 2
            dot.backgroundColor = UIColor.white
            cardView.addSubview(dot)
        }
        
        
    }
    
    func drawDottedLine(start p0 : CGPoint, end p1 : CGPoint, view : UIView){
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [10, 5]
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    
    @objc func nextPressed(){
        self.presentFullScreen(DatasetViewController(), animated: true, completion: nil)
    }
    
}

