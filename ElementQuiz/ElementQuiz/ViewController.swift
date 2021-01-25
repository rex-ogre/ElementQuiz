//
//  ViewController.swift
//  ElementQuiz
//
//  Created by 陳冠雄 on 2021/1/18.
//

import UIKit
enum Mode {
    case flahCard
    case quiz
}
enum State {
    case question
    case answer
    case score
}


class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        updateUI()
    }
    @IBOutlet weak var nextElement: UIButton!
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
}
            
        }
        state = .question
        updateUI()
        
    }
    
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flahCard
        } else {
            mode = .quiz
        }
    }
    
    
    //Quiz-prepare
    var elementList = ["Carbon", "Gold", "Chlorine", "Sodium"
    ]
    var currentElementIndex = 0
    var mode : Mode = .flahCard { didSet {switch mode{
    case.flahCard : setupFlashCards()
    case .quiz: setupQuiz()
    }; updateUI()}}
    var state : State = .question
    //Quiz-speific state
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    //Updates the app's UI in flash card mode.
    func updateFlashCardUI(elementName : String) {
        //Text field and keyboard
        textField.isHidden = true
        textField.resignFirstResponder()
        //Answer Label
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
        //Segment control
        modeSelector.selectedSegmentIndex = 0
        // Buttons
        showAnswerButton.isHidden = false
        nextElement.isEnabled = true
        nextElement.setTitle("Next Element", for: .normal)
    }
    
    //Updates the app's UI in quiz mode
 
    //Update the app's UI based on its mode and state.
    func updateUI()  {
        // Shared code: updating the image
        let elementName = elementList[currentElementIndex]
        
        let image = UIImage(named: elementName)
        imageView.image = image
        switch  mode {
        case .flahCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }
    // Runs after the user hits the Return key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // get the text from text field
        let textFieldContents = textField.text
        //Determine whether the user answered correctly and update appropriate quiz
        //state
        if textFieldContents?.lowercased() ==
            elementList[currentElementIndex].lowercased(){
            answerIsCorrect = true
            correctAnswerCount += 1
        }
        else{
            answerIsCorrect = false
        }
        //The app should now display the answer to the user
        state = .answer
        updateUI()
        if answerIsCorrect {
            print("correct")
        } else {
            print("no")
        }
        return true
    }
    //Update the app's UI in quiz mode.
    func updateQuizUI(elementName : String) {
        
        modeSelector.selectedSegmentIndex = 1
        //Text field and keyboard
        textField.isHidden = false
        switch state {
        case .question:
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.resignFirstResponder()
        case.score:
            textField.isHidden = true
            textField.resignFirstResponder()
            answerLabel.text = ""
            print("Your score is \(correctAnswerCount) out of \(elementList.count).")
        }
        if state == .score {
            displayScoreAlert()
        }
        
        
        //Answer Label
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect{
                answerLabel.text = "correct!"
            } else {
                answerLabel.text = "wrong \nCorrect Answer :" + elementName
            }
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        //Buttons
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1  {
            nextElement.setTitle("show score", for: .normal)
        } else {
            nextElement.setTitle("next Question", for: .normal)
        }
        switch state {
        case .question:
            nextElement.isEnabled = false
        case .answer:
            nextElement.isEnabled = true
        case .score:
            nextElement.isEnabled = false
        }
        //Text field and keyboard
        textField.isHidden = false
        switch state {
        case .question:
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
    }
    //Shows an ios alert with the user's quiz score
    func displayScoreAlert(){
        let alert = UIAlertController (title: "Quiz score", message: "your score is \(correctAnswerCount) out of \(elementList.count)", preferredStyle: .alert)
        let dismissAction = UIAlertAction (title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
        
    }
    func scoreAlertDismissed(_ action : UIAlertAction) {
        mode = .flahCard
    }
   //Sets up a new flash card session.
    func setupFlashCards() {
        state = .question
        currentElementIndex = 0
    }
    func setupQuiz()  {
        elementList = elementList.shuffled()
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        updateUI()
        
        // Do any additional setup after loading the view.
    }


}

