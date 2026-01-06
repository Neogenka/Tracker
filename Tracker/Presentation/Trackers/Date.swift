import UIKit

extension TrackersViewController {
    @objc func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
    }
}
