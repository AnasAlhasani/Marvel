// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
    public enum Character {
        /// Comics
        public static let comics = L10n.tr("Localizable", "character.comics")
        /// Description
        public static let description = L10n.tr("Localizable", "character.description")
        /// Name
        public static let name = L10n.tr("Localizable", "character.name")
        /// Series
        public static let series = L10n.tr("Localizable", "character.series")
    }

    public enum Common {
        /// Not Available.
        public static let notAvailable = L10n.tr("Localizable", "common.notAvailable")
    }

    public enum Error {
        /// Failed to decode response.
        public static let decode = L10n.tr("Localizable", "error.decode")
        /// Something went wrong.\nPlease try again later
        public static let general = L10n.tr("Localizable", "error.general")
    }

    public enum Search {
        /// Search
        public static let title = L10n.tr("Localizable", "search.title")
    }

    public enum State {
        /// No Results Found!
        public static let empty = L10n.tr("Localizable", "state.empty")
        /// Ooops!
        public static let error = L10n.tr("Localizable", "state.error")
    }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
