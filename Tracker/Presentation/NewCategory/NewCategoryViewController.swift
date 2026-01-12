import UIKit

final class NewCategoryViewController: UIViewController {
    private let viewModel: NewCategoryViewModel
    private let customView = NewCategoryView()
    
    init(viewModel: NewCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }
    override func loadView() {
        view = customView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupActions()
        setupKeyboardDismiss()
    }
    private func setupKeyboardDismiss() {
        customView.nameTextField.textField.returnKeyType = .done
        customView.nameTextField.textField.addTarget(self, action: #selector(hideKeyboard), for: .editingDidEndOnExit)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    private func setupBindings() {
        viewModel.isButtonEnabled = { [weak self] enabled in
            self?.customView.doneButton.isEnabled = enabled
        }
        viewModel.onCategoryCreated = { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    private func setupActions() {
        customView.nameTextField.onTextChanged = { [weak self] text in
            self?.viewModel.categoryName = text
        }
        customView.doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }
    @objc private func doneTapped() {
        view.endEditing(true)
        viewModel.saveCategory()
    }
}
