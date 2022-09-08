import CoreGraphics
import Foundation

/// A group of items to be displayed in a toolbar.
///
/// Tool groups are evenly distributed in the toolbar. Use ``KeyboardToolGroup/spacing`` to specify the spacing within the group.
public struct KeyboardToolGroup {
    /// The spacing between items in the group.
    ///
    /// The default value is 6.
    public let spacing: CGFloat
    /// Set to give a fixed spacer after this group (in place of flexible spacing)
    public let fixedSpaceAfter: CGFloat?
    /// The items to be displayed in the group.
    public let items: [KeyboardToolGroupItem]

    /// Initializes a tool group.
    /// - Parameters:
    ///   - spacing: The spacing between items in the group. Defaults to 6.
    ///   - items: The items to be displayed in the group.
    public init(spacing: CGFloat = 6, fixedSpaceAfter: CGFloat? = nil, items: [KeyboardToolGroupItem]) {
        self.spacing = spacing
        self.fixedSpaceAfter = fixedSpaceAfter
        self.items = items
    }
}
