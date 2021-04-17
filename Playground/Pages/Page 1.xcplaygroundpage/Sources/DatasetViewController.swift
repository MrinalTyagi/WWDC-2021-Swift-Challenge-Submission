//The following view controller explains and showcases the dataset that will be used during the training by the neural network. The view controller contains a table showcasing various features that will be input to the neural network. These features include Sepal Length, Sepal Width, Petal Length and Petal Width. The dataset displayed inside the table contains some of the instances actually used in the training process and are loaded on the dataset table from the same .csv file that will be used for training the model.


import Foundation
import UIKit
import PlaygroundSupport

public class DatasetViewController : UIViewController{
    
    var bottomText : Array<String> = ["The above table contains the dataset that will be used to train the Neural Network.", "Various features of the dataset including Sepal Length, Sepal Width, Petal Length and Petal Width will be used by the neural network in order to predict their variety.", "The varieties predicted by the Neural Network include Setosa, Virginica and Versicolor."]
    var index : Int = 0
    var bottomView : UIView!
    var textLabel : UILabel!
    var backButton : UIButton!
    var nextScreenButton : UIButton!
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        let cfURL = Bundle.main.url(forResource: "Montserrat-SemiBold", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        setupUI()
    }
    
    public func setupUI(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 701, height: 900))
        imageView.image = UIImage(named: "back.png")
        self.view.addSubview(imageView)
        let tableView = UIView(frame: CGRect(x: 217, y: 230, width: 299, height: 390))
        self.view.addSubview(tableView)
        
        let datasetCard = UIView()
        datasetCard.frame = CGRect(x: 19, y: 16.6, width: 260.75, height: 353.36)
        datasetCard.backgroundColor = UIColor(red: 12/255, green: 159/255, blue: 179/255, alpha: 1.0)
        datasetCard.clipsToBounds = true
        datasetCard.layer.cornerRadius = 12
        tableView.addSubview(datasetCard)
        
        
        //MARK: - Dataset View
        let titles = ["x1", "x2", "x3", "x4"]
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
        
        let stacks = UIStackView()
        stacks.frame = CGRect(x: 15, y: 15, width: datasetCard.frame.width - 30, height: datasetCard.frame.height - 30)
        datasetCard.addSubview(stacks)
        stacks.axis = .vertical
        stacks.distribution = .fillEqually
        stacks.spacing = 3

        for i in 0...4{
            let stack1 : UIStackView = UIStackView()
            stack1.frame = CGRect(x: 15, y: 15, width: datasetCard.frame.width - 30, height: 59)
            stack1.axis = .horizontal
            stack1.distribution = .fillEqually
            stack1.spacing = 3
            stacks.addArrangedSubview(stack1)
            for j in 0...3{
                if i == 0{
                    let view = DatasetView(text: titles[j], isHead: true)
                    stack1.addArrangedSubview(view)
                    view.setupView()
                }else{
                    let view = DatasetView(text: "\(X[i][j])", isHead: false)
                    stack1.addArrangedSubview(view)
                    view.setupView()
                }

            }
            
        }

        //MARK: - Dashed Lines
        let dashedLineHorizontal = UIView()
        dashedLineHorizontal.frame = CGRect(x: 10, y: 10, width: 175.0, height: 5)
        drawDottedLine(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 175.0, y: 0), view: dashedLineHorizontal)
        tableView.addSubview(dashedLineHorizontal)
        
        let dashedLineVertical = UIView()
        dashedLineVertical.frame = CGRect(x: 5, y: 5, width: 200.0, height: 5)
        drawDottedLine(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 200.0), view: dashedLineVertical)
        tableView.addSubview(dashedLineVertical)
        
        
        //        Vertical Dots
        for i in 0...4{
            let dot = UIView()
            dot.frame = CGRect(x: 0, y: 5 + Double(i) * 50.0, width: 11.54, height: 11.54)
            dot.clipsToBounds = true
            dot.layer.cornerRadius = dot.layer.frame.size.height / 2
            dot.backgroundColor = UIColor.white
            tableView.addSubview(dot)
        }
        
        //        Horizontal Dots
        for i in 0...3{
            let dot = UIView()
            dot.frame = CGRect(x: 0 + Double(i + 1) * 44.00 , y: 5, width: 8.54, height: 8.54)
            dot.clipsToBounds = true
            dot.layer.cornerRadius = dot.layer.frame.size.height / 2
            dot.backgroundColor = UIColor.white
            tableView.addSubview(dot)
        }
        
        
        let dashedLineHorizontal2 = UIView()
        dashedLineHorizontal2.frame = CGRect(x: 87.71, y: tableView.frame.height - 5 , width: 206.29, height: 5)
        drawDottedLine(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 206.29, y: 0), view: dashedLineHorizontal2, color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor)
        tableView.addSubview(dashedLineHorizontal2)
        
        let dashedLineVertical2 = UIView()
        dashedLineVertical2.frame = CGRect(x: 294, y: 87.71, width: 297.29, height: 5)
        drawDottedLine(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 297.29), view: dashedLineVertical2, color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor)
        tableView.addSubview(dashedLineVertical2)
        
        let dot = UIView()
        dot.frame = CGRect(x: 82.71, y: tableView.frame.height - 10, width: 10, height: 10)
        dot.clipsToBounds = true
        dot.layer.cornerRadius = dot.layer.frame.height / 2
        dot.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        tableView.addSubview(dot)
        
        
        //MARK: - Label
        let datasetLabel = UILabel()
        datasetLabel.frame = CGRect(x: 46, y: 30, width: self.view.frame.width - 92, height: 50)
        datasetLabel.text = "Dataset used in Training"
        datasetLabel.font = UIFont(name: "Montserrat-SemiBold", size: 40)
        datasetLabel.textAlignment = .center
        datasetLabel.numberOfLines = 0
        datasetLabel.textColor = .white
        self.view.addSubview(datasetLabel)
        
        let labels = UILabel()
        labels.frame = CGRect(x: 46, y: 120, width: self.view.frame.width - 92, height: 60)
        labels.numberOfLines = 0
        labels.text = "x1 => Sepal Length\tx2 => Sepal Width\nx3 => Petal Length\tx4 => Petal Width"
        labels.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        labels.textColor = .white
        labels.textAlignment = .center
        self.view.addSubview(labels)
        
        
        //MARK: - Bottom Section
        self.bottomView = UIView()
        self.bottomView.frame = CGRect(x: 60, y: 700, width: self.view.frame.width - 120, height: 150)
        self.bottomView.clipsToBounds = true
        self.bottomView.layer.cornerRadius = 20
        self.bottomView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        self.view.addSubview(self.bottomView)
        
        self.textLabel = UILabel()
        self.bottomView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        textLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 30).isActive = true
        textLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -30).isActive = true
        textLabel.text = bottomText[index]
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        textLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        
        let nextButton = UIButton()
        bottomView.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -10).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        nextButton.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
        nextButton.titleLabel?.textColor = UIColor.white
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(nextItem), for: .touchUpInside)

        
        let skipButton = UIButton()
        bottomView.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 10).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        skipButton.setTitle("Skip", for: .normal)
        skipButton.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
        skipButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        skipButton.titleLabel?.textColor = .white
        skipButton.clipsToBounds = true
        skipButton.layer.cornerRadius = 10
        skipButton.addTarget(self, action: #selector(skipText), for: .touchUpInside)

        
        
        //MARK: - Button
        nextScreenButton = UIButton()
        nextScreenButton.frame = CGRect(x: 263, y: 726, width: 186, height: 55.27)
        nextScreenButton.setTitle("NEXT", for: .normal)
        nextScreenButton.titleLabel?.textColor = UIColor.white
        nextScreenButton.backgroundColor = UIColor(red: 10/255, green: 136/255, blue: 154/255, alpha: 1.0)
        nextScreenButton.clipsToBounds = true
        nextScreenButton.layer.cornerRadius = 27.8
        nextScreenButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        self.view.addSubview(nextScreenButton)
        nextScreenButton.isHidden = true
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
        self.presentFullScreen(NeuralNetworkViewController(), animated: true, completion: nil)
    }
        
    @objc func skipText(){
        index = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.bottomView.alpha = 0
        } completion: { (_) in
            self.bottomView.isHidden = true
            self.nextScreenButton.alpha = 0
            self.nextScreenButton.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.nextScreenButton.alpha = 1
            }
            
        }
        
    }
    
    @objc func nextItem(){
        index += 1
        if index < 3{
            UIView.animate(withDuration: 0.2) {
                self.textLabel.alpha = 0
            }
            textLabel.text = bottomText[index]
            UIView.animate(withDuration: 0.2) {
                self.textLabel.alpha = 1.0
            }
            
        }
        else if index >= 3{
            index = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
                self.bottomView.alpha = 0
            } completion: { (_) in
                self.bottomView.isHidden = true
                self.nextScreenButton.alpha = 0
                self.nextScreenButton.isHidden = false
                UIView.animate(withDuration: 1) {
                    self.nextScreenButton.alpha = 1
                }
                
            }

        }
        
    }
    
    
    func drawDottedLine(start p0 : CGPoint, end p1 : CGPoint, view : UIView, color : CGColor = UIColor.white.cgColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [10, 5]
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
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


class DatasetView : UIView{
    var text : String
    var isHead : Bool
    
    init(text : String, isHead : Bool = false) {
        self.text = text
        self.isHead = isHead
        super.init(frame: CGRect(x: 0, y: 0, width: 55.9, height: 59.0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func setupView(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 3
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.12)
        let label = UILabel()
        self.addSubview(label)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.frame.size = CGSize(width: self.frame.width - 5, height: self.frame.height - 5)
        label.text = self.text
        if self.isHead{
            label.font = UIFont(name: "Montserrat-SemiBold", size: 25)
        }else{
            label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
