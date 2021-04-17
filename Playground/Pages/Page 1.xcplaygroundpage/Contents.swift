/*The following Playground is an interactive playground made in order to educate about working of a neural network which is made from scratch in this project.
1. Click on the Get started button to start the playground.
2. Then the Dataset View Controller is showcased which displays the dataset that will be used from training the neural network.
3. Next step involves training of the neural network. The neural network used here has 4 inputs and a hidden layer of 5 neurons and an output layer for 3 classes.
4. The results of the training process are presented on the next view controller.
5. After that the user can input Double values in text field in order to output the class predicted by the neural network.
*/


import UIKit
import PlaygroundSupport

let start = GettingStartedViewController(size: CGSize(width: 701, height: 900))
PlaygroundPage.current.liveView = start

