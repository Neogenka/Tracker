import UIKit

final class ContainerTableViewCell: UITableViewCell {

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption2
        label.textColor = AppColors.backgroundBlackButton
        label.numberOfLines = 1
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

    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var titleTopConstraint: NSLayoutConstraint!
    private var titleCenterYConstraint: NSLayoutConstraint!

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

    // MARK: - Configure

    func configure(title: String, subtitle: String?) {
        titleLabel.text = title

        if let subtitle, !subtitle.isEmpty {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false

            titleCenterYConstraint.isActive = false
            titleTopConstraint.isActive = true
        } else {
            subtitleLabel.text = nil
            subtitleLabel.isHidden = true

            titleTopConstraint.isActive = false
            titleCenterYConstraint.isActive = true
        }
    }

    func configureAccessory(imageName: String?) {
        guard let imageName, let image = UIImage(named: imageName) else {
            accessoryView = nil
            return
        }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        accessoryView = imageView
    }

    // MARK: - Private

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(separatorLine)

        let inset: CGFloat = 16

        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        titleCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -inset),

            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -inset),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15),

            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        titleCenterYConstraint.isActive = true
        subtitleLabel.isHidden = true
    }
}
