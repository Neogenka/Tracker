import UIKit

final class ContainerTableViewCell: UITableViewCell {

    // MARK: - Public
    var isLastCell: Bool = false {
        didSet { separatorLine.isHidden = isLastCell }
    }

    func configure(title: String, subtitle: String? = nil) {
        titleLabel.text = title

        let subtitleText = subtitle?.trimmingCharacters(in: .whitespacesAndNewlines)
        subtitleLabel.text = subtitleText
        subtitleLabel.isHidden = (subtitleText?.isEmpty ?? true)
    }

    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()

    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()

    // MARK: - Separator
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray4
        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupStyle() {
        backgroundColor = .systemGray6
        contentView.backgroundColor = .systemGray6
        selectionStyle = .none
        accessoryType = .none
    }

    private func setupLayout() {
        contentView.addSubview(labelsStack)
        contentView.addSubview(separatorLine)

        // Важно: оставляем место справа под disclosureIndicator / UISwitch
        NSLayoutConstraint.activate([
            labelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -80),
            labelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
