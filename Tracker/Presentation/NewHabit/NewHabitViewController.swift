import UIKit

final class NewHabitViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let modalHeader = ModalHeaderView(title: "Новая привычка")
    private let nameTextField = AppTextField(placeholder: "Введите название трекера")
    private let tableContainer = ContainerTableView()
    private let emojiCollectionVC = SelectableCollectionViewController(items: CollectionData.emojis, headerTitle: "Emoji")
    private let colorCollectionVC = SelectableCollectionViewController(items: CollectionData.colors, headerTitle: "Цвет")
    private let bottomButtons = ButonsPanelView()
    
    // MARK: - Callback
    var onHabitCreated: ((Tracker) -> Void)?
    
    // MARK: - State
    private var selectedDays: [WeekDay] = []
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    private var selectedCategory: TrackerCategoryCoreData?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        
        setupTable()
        setupLayout()
        setupActions()
        
        nameTextField.delegate = self
        print("➕ NewHabitViewController загружен")
        
        // Обработка выбора эмоджи
        emojiCollectionVC.onItemSelected = { [weak self] item in
            if case .emoji(let emoji) = item {
                self?.selectedEmoji = emoji
            }
        }
        
        // Обработка выбора цвета
        colorCollectionVC.onItemSelected = { [weak self] item in
            if case .color(let color) = item {
                self?.selectedColor = color
            }
        }
    }
    
    // MARK: - Table setup
    private func setupTable() {
        let tableView = tableContainer.tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContainerTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 75
        tableContainer.updateHeight(forRows: 2)
    }
    
    // MARK: - Layout
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = AppLayout.padding
        
        // Header и кнопки вне scrollView
        modalHeader.translatesAutoresizingMaskIntoConstraints = false
        bottomButtons.translatesAutoresizingMaskIntoConstraints = false
        modalHeader.backgroundColor = AppColors.background
        bottomButtons.backgroundColor = AppColors.background
        
        view.addSubview(modalHeader)
        view.addSubview(scrollView)
        view.addSubview(bottomButtons)

        let panelSafeBottom = bottomButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        panelSafeBottom.priority = .init(998)

        // ScrollView содержит stackView
        scrollView.addSubview(contentStack)
        
        // Добавляем сабвьюхи
        [nameTextField, tableContainer, emojiCollectionVC.view, colorCollectionVC.view].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentStack.addArrangedSubview($0)
        }
        
        // Child VC
        addChild(emojiCollectionVC)
        emojiCollectionVC.didMove(toParent: self)
        
        addChild(colorCollectionVC)
        colorCollectionVC.didMove(toParent: self)
        
        // Кастомный spacing между коллекциями
        contentStack.setCustomSpacing(0, after: emojiCollectionVC.view)
        
        NSLayoutConstraint.activate([
            modalHeader.topAnchor.constraint(equalTo: view.topAnchor),
            modalHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalHeader.heightAnchor.constraint(equalToConstant: 90),
            
            bottomButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            panelSafeBottom,
            
            scrollView.topAnchor.constraint(equalTo: modalHeader.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomButtons.topAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AppLayout.padding),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: UIConstants.horizontalPadding),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -UIConstants.horizontalPadding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -AppLayout.padding),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2*UIConstants.horizontalPadding),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            tableContainer.heightAnchor.constraint(equalToConstant: 150),
            emojiCollectionVC.view.heightAnchor.constraint(equalToConstant: collectionHeight(itemsCount: CollectionData.emojis.count)),
            colorCollectionVC.view.heightAnchor.constraint(equalToConstant: collectionHeight(itemsCount: CollectionData.colors.count))
        ])
    }

    private func collectionHeight(itemsCount: Int, columns: Int = 6) -> CGFloat {
        let rows = CGFloat((itemsCount + columns - 1) / columns)
        let itemSize: CGFloat = 52
        let lineSpacing: CGFloat = 5
        let headerHeight: CGFloat = 44
        return headerHeight + rows * itemSize + max(0, rows - 1) * lineSpacing
    }

    private func scheduleSummary(from days: [WeekDay]) -> String? {
        guard !days.isEmpty else { return nil }

        let uniqueSorted = Array(Set(days)).sorted { $0.rawValue < $1.rawValue }
        if uniqueSorted.count == WeekDay.allCases.count {
            return "Каждый день"
        }

        return uniqueSorted.map { $0.shortTitle }.joined(separator: ", ")
    }

    // MARK: - Actions
    private func setupActions() {
        bottomButtons.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        bottomButtons.createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }
    
    @objc private func cancelTapped() {
        print("✖️ NewHabitViewController: отмена")
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
        guard let title = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else { return }
        guard let emoji = selectedEmoji else {
            print("⚠️ Выберите эмодзи")
            return
        }
        guard let color = selectedColor else {
            print("⚠️ Выберите цвет")
            return
        }
        
        let tracker = Tracker(
            id: UUID(),
            name: title,
            color: color.toHexString(),
            emoji: emoji,
            schedule: selectedDays,
            trackerCategory: selectedCategory
        )
        
        onHabitCreated?(tracker)
        dismissToRoot()
    }
    

    private func dismissToRoot() {
            var presenter = presentingViewController
            while let next = presenter?.presentingViewController {
                presenter = next
            }
            presenter?.dismiss(animated: true)
    }

    // MARK: - UITextField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let hasText = !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        bottomButtons.setCreateButton(enabled: hasText)
    }
}

// MARK: - UITableView
extension NewHabitViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContainerTableViewCell
        if indexPath.row == 0 {
            cell.configure(title: "Категория", subtitle: selectedCategory?.title)
        } else {
            cell.configure(title: "Расписание", subtitle: scheduleSummary(from: selectedDays))
        }
        cell.accessoryType = .disclosureIndicator
        cell.isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            // Переход к CategoryViewController
            let coreDataStack = CoreDataStack.shared
            let categoryStore = TrackerCategoryStore(context: coreDataStack.context)
            let categoryVC = CategoryViewController(store: categoryStore)

            categoryVC.onCategorySelected = { [weak self, weak categoryVC] category in
                self?.selectedCategory = category
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                categoryVC?.dismiss(animated: true)
            }

            present(categoryVC, animated: true)
        }

        if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController()
            scheduleVC.selectedDays = selectedDays
            scheduleVC.onDone = { [weak self] days in
                self?.selectedDays = days
                tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
            present(scheduleVC, animated: true)
        }
    }
}

// MARK: - UIColor extension
extension UIColor {
    func toHexString() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX",
                      lroundf(r * 255),
                      lroundf(g * 255),
                      lroundf(b * 255))
    }
}
