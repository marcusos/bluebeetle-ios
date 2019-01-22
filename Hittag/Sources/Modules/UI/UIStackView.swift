import UIKit
import ModuleArchitecture

extension UIView {
    func wrapForPadding(_ padding: UIEdgeInsets) -> UIStackView {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = padding
        stackView.addArrangedSubview(self)
        return stackView
    }
    
    func wrapForPaddingWithContainer(_ padding: UIEdgeInsets) -> UIView {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = padding
        stackView.addArrangedSubview(self)
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)
        stackView.makeEdgesEqualToSuperview()
        return container
    }
    
    func wrapForHorizontalAlignment(_ alignment: UIStackView.Alignment = .center) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = alignment
        stackView.addArrangedSubview(self)
        return stackView
    }
    
    func wrapForVerticalAlignment(_ alignment: UIStackView.Alignment = .center) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = alignment
        stackView.addArrangedSubview(self)
        return stackView
    }
}

extension UIStackView {
    
    /**
     This method is meant to be used when the stackview has only subviews of the same type.
     The Stackview will manage it's own arranged subviews, inserting or removing them
     as needed, based on the number of viewModels passed
     */
    func render<Configuration, Cell: UIView>(configurations: [Configuration], factory: () -> Cell)
        where Cell: Component, Cell.Configuration == Configuration {
            self.updateSubviewsWith(configurations: configurations, factory: factory)
            self.removeUnusedCells(viewModelsCount: configurations.count)
    }
    
    private func updateSubviewsWith<Configuration, Cell: UIView>(configurations: [Configuration], factory: () -> Cell)
        where Cell: Component, Cell.Configuration == Configuration {
            for (index, configuration) in configurations.enumerated() {
                let cell = self.dequeueReusableCell(for: index, factory: factory) as Cell
                cell.render(configuration: configuration)
            }
    }
    
    private func removeUnusedCells(viewModelsCount: Int) {
        let currentSubviewsCount = self.arrangedSubviews.count
        let numberOfItems = viewModelsCount
        let diff = max(currentSubviewsCount - numberOfItems, 0)
        
        for _ in 0..<diff {
            let lastIndex = self.arrangedSubviews.count - 1
            let view = self.arrangedSubviews[lastIndex]
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    private func willAddArrangedSubview(_ subview: UIView) {
        // setting the subview hidden before inserting allows animated insertions
        // `render(configuration: _)` is called inside an animation block
        subview.isHidden = true
    }
    
    private func didAddArrangedSubview(_ subview: UIView) {
        subview.isHidden = false
    }
    
    private func dequeueReusableCell<Cell: UIView>(for index: Int, factory: () -> Cell) -> Cell {
        let arrangedSubviews = self.arrangedSubviews
        if arrangedSubviews.count > index, let cell = arrangedSubviews[index] as? Cell {
            return cell
        } else {
            let cell = factory()
            self.willAddArrangedSubview(cell)
            self.addArrangedSubview(cell)
            self.didAddArrangedSubview(cell)
            return cell
        }
    }
}

private func defaultCellFactory<Configuration, Cell: UIView>() -> Cell
    where Cell: Component, Cell.Configuration == Configuration {
        return Cell()
}
