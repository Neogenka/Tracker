import UIKit

final class ContainerTableViewCell: UITableViewCell {

    // MARK: - UI
    private let leftPaddingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray4
        view.layer.zPosition = 1
        return view
    }()

    // MARK: - State
    var isLastCell: Bool = false {
        didSet { separatorLine.isHidden = isLastCell }
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configure(title: String, subtitle: String?) {
        titleLabel.text = title
        let subtitle = subtitle?.trimmingCharacters(in: .whitespacesAndNewlines)
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = (subtitle?.isEmpty ?? true)
    }

    // MARK: - Private
    private func setupUI() {
        selectionStyle = .default
        backgroundColor = .systemGray6
        contentView.backgroundColor = .systemGray6

        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitleLabel)

        contentView.addSubview(leftPaddingView)
        contentView.addSubview(labelsStack)
        contentView.addSubview(separatorLine)

        NSLayoutConstraint.activate([
            leftPaddingView.widthAnchor.constraint(equalToConstant: 20),
            leftPaddingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftPaddingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leftPaddingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            labelsStack.leadingAnchor.constraint(equalTo: leftPaddingView.trailingAnchor),
            labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            labelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            labelsStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
