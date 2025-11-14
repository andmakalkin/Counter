import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var plusButton: UIButton!
    @IBOutlet weak private var plusOneAnimatedLabel: UILabel!
    @IBOutlet weak private var minusButton: UIButton!
    @IBOutlet weak private var minusOneAnimatedLabel: UILabel!
    @IBOutlet weak private var resetButton: UIButton!
    @IBOutlet weak private var historyTextView: UITextView!
    @IBOutlet weak private var counterLabel: UILabel!
    private var countValue: Int = 0
    private var messageForHistory: Message = .plus
    private var currentDateTime: String {
        let dateTime = DateFormatter()
        dateTime.dateFormat = "dd.MM.yyyy HH:mm"
        return dateTime.string(from: Date())
    }
    
    private enum Message: String {
        case plus = "Значение изменено на +1"
        case minus = "Значение изменено на -1"
        case reset = "Значение сброшено"
        case error = "Попытка уменьшить значение счётчика ниже 0"
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
    
    private func updateCounterLabel() {
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
    
    private func animatePlusOne() {
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
    
    private func animateMinusOne() {
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
    
    private func updateHistoryTextView() {
        historyTextView.text += "\n[\(currentDateTime)] \(messageForHistory.rawValue)"
    }
    
    private func scrollHistoryTextView() {
        let range = NSRange(location: historyTextView.text.count - 1, length: 1)
        historyTextView.scrollRangeToVisible(range)
    }
    
    @IBAction private func plusButtonDidTap(_ sender: Any) {
        countValue += 1
        messageForHistory = .plus
        animatePlusOne()
        updateCounterLabel()
        updateHistoryTextView()
        scrollHistoryTextView()
    }
    
    @IBAction private func minusButtonDidTap(_ sender: Any) {
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
    
    @IBAction private func resetButtonDidTap(_ sender: Any) {
        countValue = 0
        messageForHistory = .reset
        updateCounterLabel()
        updateHistoryTextView()
        scrollHistoryTextView()
    }
}
