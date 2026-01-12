//
//  BaseTrackerCreationViewController.swift
//  Tracker
//
//  Created by МAK on 11.01.2026.
//

import CoreData
import UIKit
class BaseTrackerCreationViewController: UIViewController {
    @objc func categoryFieldTapped() {}
        @objc func scheduleFieldTapped() {}
    let scrollView = UIScrollView()
    let contentStack = UIStackView()
    let modalHeader: ModalHeaderView
    let nameTextField = AppTextField(
        placeholder: NSLocalizedString("new_habit.enter_name", comment: ""),
        maxCharacters: 38
    )
    let tableContainer = ContainerTableView()
    let emojiCollectionVC = SelectableCollectionViewController(
        items: CollectionData.emojis,
        headerTitle: NSLocalizedString("new_habit.emoji", comment: "")
    )
    let colorCollectionVC = SelectableCollectionViewController(
        items: CollectionData.colors,
        headerTitle: NSLocalizedString("new_habit.color", comment: "")
    )
    private var emojiHeightConstraint: NSLayoutConstraint?
    private var colorHeightConstraint: NSLayoutConstraint?

    let bottomButtons = ButonnsPanelView()
    let context = CoreDataStack.shared.context
    var selectedDays: [WeekDay] = []
    var selectedEmoji: String?
    var selectedColor: UIColor?
    var selectedCategory: TrackerCategoryCoreData?
    init(title: String) {
        modalHeader = ModalHeaderView(title: title)
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupTable()
        setupLayout()
        setupActions()
        setupSelectionCallbacks()
        setupTextField()
        setupKeyboardDismiss()
    }
    private func setupKeyboardDismiss() {
        scrollView.keyboardDismissMode = .onDrag

        nameTextField.textField.returnKeyType = .done
        nameTextField.textField.addTarget(self, action: #selector(hideKeyboard), for: .editingDidEndOnExit)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    private func setupTextField() {
        nameTextField.onTextChanged = { [weak self] text in
            let hasText = !text.trimmingCharacters(in: .whitespaces).isEmpty
            self?.bottomButtons.setCreateButton(enabled: hasText)
        }
    }
    private func setupSelectionCallbacks() {
        emojiCollectionVC.onItemSelected = { [weak self] item in
            if case let .emoji(emoji) = item { self?.selectedEmoji = emoji }
        }
        colorCollectionVC.onItemSelected = { [weak self] item in
            if case let .color(color) = item { self?.selectedColor = color }
        }
    }
    private func setupTable() {
        let tableView = tableContainer.tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContainerTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 75
    }
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = AppLayout.padding
        modalHeader.translatesAutoresizingMaskIntoConstraints = false
        bottomButtons.translatesAutoresizingMaskIntoConstraints = false
        modalHeader.backgroundColor = AppColors.background
        bottomButtons.backgroundColor = AppColors.background
        view.addSubview(modalHeader)
        view.addSubview(scrollView)
        view.addSubview(bottomButtons)
        scrollView.addSubview(contentStack)
        let subviews: [UIView] = [
            nameTextField,
            tableContainer,
            emojiCollectionVC.view ?? UIView(),
            colorCollectionVC.view ?? UIView()
        ]
        for item in subviews {
            item.translatesAutoresizingMaskIntoConstraints = false
            contentStack.addArrangedSubview(item)
        }
        addChild(emojiCollectionVC)
        emojiCollectionVC.didMove(toParent: self)
        addChild(colorCollectionVC)
        colorCollectionVC.didMove(toParent: self)

        let availableWidth = view.bounds.width > 0
            ? (view.bounds.width - 2 * UIConstants.horizontalPadding)
            : (UIScreen.main.bounds.width - 2 * UIConstants.horizontalPadding)

        emojiHeightConstraint = emojiCollectionVC.view.heightAnchor.constraint(
            equalToConstant: collectionSectionHeight(itemsCount: CollectionData.emojis.count, availableWidth: availableWidth)
        )
        colorHeightConstraint = colorCollectionVC.view.heightAnchor.constraint(
            equalToConstant: collectionSectionHeight(itemsCount: CollectionData.colors.count, availableWidth: availableWidth)
        )
        emojiHeightConstraint?.isActive = true
        colorHeightConstraint?.isActive = true
        let bottomSafeBottom = bottomButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomSafeBottom.priority = .init(998)

        let bottomKeyboardBottom = bottomButtons.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        bottomKeyboardBottom.priority = .init(999)

        let bottomClamp = bottomButtons.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomClamp.priority = .required

        NSLayoutConstraint.activate([
            modalHeader.topAnchor.constraint(equalTo: view.topAnchor),
            modalHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalHeader.heightAnchor.constraint(equalToConstant: 90),
            bottomButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: modalHeader.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomButtons.topAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AppLayout.padding),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: UIConstants.horizontalPadding),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -UIConstants.horizontalPadding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -AppLayout.padding),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * UIConstants.horizontalPadding),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            tableContainer.heightAnchor.constraint(equalToConstant: 150),
            bottomSafeBottom,
            bottomKeyboardBottom,
            bottomClamp,
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let availableWidth = view.bounds.width - 2 * UIConstants.horizontalPadding
        emojiHeightConstraint?.constant = collectionSectionHeight(itemsCount: CollectionData.emojis.count, availableWidth: availableWidth)
        colorHeightConstraint?.constant = collectionSectionHeight(itemsCount: CollectionData.colors.count, availableWidth: availableWidth)
    }

    private func collectionSectionHeight(itemsCount: Int, availableWidth: CGFloat) -> CGFloat {
        let itemSide: CGFloat = 52
        let spacing: CGFloat = 5
        let headerHeight: CGFloat = 44

        let columns = max(1, Int((availableWidth + spacing) / (itemSide + spacing)))
        let rows = Int(ceil(Double(itemsCount) / Double(columns)))

        let gridHeight = CGFloat(rows) * itemSide + CGFloat(max(0, rows - 1)) * spacing
        return headerHeight + gridHeight
    }

private func setupActions() {
        bottomButtons.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    func numberOfRowsInTable() -> Int { 2 }
    func tableViewCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContainerTableViewCell
        if indexPath.row == 0 {
            cell.configure(title: NSLocalizedString("new_habit.category", comment: ""), detail: selectedCategory?.title ?? "")
        } else {
            let detailText = selectedDays.isEmpty ? nil : selectedDays.descriptionText
            cell.configure(title: NSLocalizedString("new_habit.schedule", comment: ""), detail: detailText)
        }
        cell.isLastCell = indexPath.row == numberOfRowsInTable() - 1
        return cell
    }
    func didSelectRow(at _: IndexPath, tableView _: UITableView) {}
}
extension BaseTrackerCreationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { numberOfRowsInTable() }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewCell(for: tableView, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath, tableView: tableView)
    }
}
