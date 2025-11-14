//
//  ViewController.swift
//  Counter
//
//  Created by Андрей Макалкин on 13.11.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var plusOneAnimatedLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var minusOneAnimatedLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var counterLabel: UILabel!
    
    private var countValue: Int = 0
    private var messageForHistory: Message = .plus
    private var currentDateTime: String {
        let dateTime = DateFormatter()
        dateTime.dateFormat = "dd.MM.yyyy HH:mm"
        return dateTime.string(from: Date())
    }
    
    enum Message: String {
        case plus = "Значение изменено на +1"
        case minus = "Значение изменено на -1"
        case reset = "Значение сброшено"
        case error = "Попытка уменьшить значение счётчика ниже 0"
    }
    
    
    
    // Обновление счётчика. Выводит лейбл в две строки: текст "Значение счётчика:" и актуальное значение countValue
    
    func updateCounterLabel() {
        
        let firstLine = NSAttributedString(
            string: "Значение счётчика:\n",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.lightGray
            ]
        )
        
        let secondLine = NSAttributedString(
            string: "\(countValue)",
            attributes: [
                .font: UIFont.systemFont(ofSize: 140),
                .foregroundColor: UIColor.black
            ]
        )
        
        let twoLines = NSMutableAttributedString()
        twoLines.append(firstLine)
        twoLines.append(secondLine)
        counterLabel.attributedText = twoLines
    }
    
    
    
    // Анимация лейбла "+1". Меняет значение alpha c 0 до 1, перемещает по оси y, меняет значение alpha c 1 до 0, возвращает лейбл в исходное положение
    
    func animatePlusOne() {
        
        plusOneAnimatedLabel.alpha = 0
        plusOneAnimatedLabel.frame.origin = CGPoint(x: 284, y: 621)
        
        UIView.animate(withDuration: 0.5) {
            self.plusOneAnimatedLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.plusOneAnimatedLabel.alpha = 0
            self.plusOneAnimatedLabel.transform = CGAffineTransform(translationX: 0, y: -53)
        } completion: { _ in
            self.plusOneAnimatedLabel.transform = .identity
        }
    }
    
    
    
    // Анимация лейбла "-1". Меняет значение alpha c 0 до 1, перемещает по оси y, меняет значение alpha c 1 до 0, возвращает лейбл в исходное положение
    
    func animateMinusOne() {
        
        minusOneAnimatedLabel.alpha = 0
        minusOneAnimatedLabel.frame.origin = CGPoint(x: 85, y: 655)
        
        UIView.animate(withDuration: 0.5) {
            self.minusOneAnimatedLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.minusOneAnimatedLabel.alpha = 0
            self.minusOneAnimatedLabel.transform = CGAffineTransform(translationX: 0, y: -53)
        } completion: { _ in
            self.minusOneAnimatedLabel.transform = .identity
        }
    }
    
    
    
    // Обновление истории изменений. Добавлят строку в historyTextView. Строка состоит из даты/времени и сообщения (enum Message)
    
    func updateHistoryTextView() {
        
        historyTextView.text += "\n[\(currentDateTime)] \(messageForHistory.rawValue)"
    }
    
    
    
    // Скролл истории изменений до последнего сообщения
    
    func scrollHistoryTextView() {
        
        let range = NSRange(location: historyTextView.text.count - 1, length: 1)
        historyTextView.scrollRangeToVisible(range)
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateCounterLabel()
        
        resetButton.layer.cornerRadius = 10
        resetButton.layer.masksToBounds = true
        
        historyTextView.text = "История изменений:"
        historyTextView.layer.cornerRadius = 10
        historyTextView.layer.masksToBounds = true
        historyTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
   
    
    
    
   
    
    // Нажатие на кнопку plusButton. Анимация при нажатии, обновление счётчика, обновление истории изменений, скролл истории изменений
    
    @IBAction func plusButtonDidTap(_ sender: Any) {
        
        countValue += 1
        messageForHistory = .plus
        
        animatePlusOne()
        updateCounterLabel()
        updateHistoryTextView()
        scrollHistoryTextView()
    }
    
    
    
    // Нажатие на кнопку minusButton. Проверка условия, что текущее значение счётчика больше 0: true [анимация при нажатии, обновление счётчика, обновление истории изменений, скролл истории изменений], false [обновление истории изменений, скролл истории изменений]
    
    @IBAction func minusButtonDidTap(_ sender: Any) {
        
        if countValue > 0 {
            countValue -= 1
            messageForHistory = .minus
            
            animateMinusOne()
            updateCounterLabel()
            updateHistoryTextView()
            
        } else {
            messageForHistory = .error
            updateHistoryTextView()
        }
        
        scrollHistoryTextView()
    }
    
    
    
    // Нажатие на кнопку resetButton. Обнуление счётчика, обновление истории изменений, скролл истории изменений
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        
        countValue = 0
        messageForHistory = .reset
        
        updateCounterLabel()
        updateHistoryTextView()
        scrollHistoryTextView()
    }
}
