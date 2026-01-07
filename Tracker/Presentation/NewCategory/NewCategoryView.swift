import UIKit

final class NewCategoryView: UIView {

    // MARK: - UI
    let header = ModalHeaderView(title: "Новая категория")
    let nameTextField = AppTextField(placeholder: "Введите название категории")
    let doneButton = BlackButton(title: "Готово")

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.background
        setupLayout()
        configureInitialState()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Layout
    private func setupLayout() {
        [header, nameTextField, doneButton].forEach { addSubview($0) }
        
        let doneSafeBottom = doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        doneSafeBottom.priority = .init(998)

        NSLayoutConstraint.activate([
            // Header сверху
            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),

            // TextField
            nameTextField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),

            // DoneButton внизу
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneSafeBottom,
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        if #available(iOS 15.0, *) {
            let clampToSafeArea = doneButton.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
            clampToSafeArea.priority = .required

            let doneKeyboardBottom = doneButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -16)
            doneKeyboardBottom.priority = .init(999)

            NSLayoutConstraint.activate([clampToSafeArea, doneKeyboardBottom])
        }
    }

    // MARK: - Initial State
    private func configureInitialState() {
        doneButton.isEnabled = false
        doneButton.backgroundColor = AppColors.gray
    }
}
