import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  static void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  static void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error, stackTrace);
  }
}

class ValidationUtils {
  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate tournament name
  static String? validateTournamentName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tournament name is required';
    }
    if (value.length < 3) {
      return 'Tournament name must be at least 3 characters';
    }
    return null;
  }

  /// Validate team name
  static String? validateTeamName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Team name is required';
    }
    if (value.length < 2) {
      return 'Team name must be at least 2 characters';
    }
    return null;
  }

  /// Validate player name
  static String? validatePlayerName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Player name is required';
    }
    if (value.length < 2) {
      return 'Player name must be at least 2 characters';
    }
    return null;
  }

  /// Validate player number
  static String? validatePlayerNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Player number is required';
    }
    final number = int.tryParse(value);
    if (number == null || number < 1 || number > 99) {
      return 'Player number must be between 1 and 99';
    }
    return null;
  }

  /// Validate date
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }
    return null;
  }

  /// Validate date range
  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 'Both dates are required';
    }
    if (endDate.isBefore(startDate)) {
      return 'End date must be after start date';
    }
    return null;
  }
}

class FormatUtils {
  /// Format match score
  static String formatScore(int homeGoals, int awayGoals) {
    return '$homeGoals - $awayGoals';
  }

  /// Format team statistics
  static String formatTeamStats(int wins, int draws, int losses) {
    return '$wins-$draws-$losses';
  }

  /// Format goal difference
  static String formatGoalDifference(int goalDifference) {
    if (goalDifference > 0) {
      return '+$goalDifference';
    } else {
      return '$goalDifference';
    }
  }

  /// Format pass accuracy
  static String formatPassAccuracy(int accuracy) {
    return '$accuracy%';
  }

  /// Format possession
  static String formatPossession(int possession) {
    return '$possession%';
  }

  /// Format player rating
  static String formatPlayerRating(double rating) {
    return rating.toStringAsFixed(1);
  }
}

class Constants {
  // App
  static const String appName = 'Football Tournament Tracker';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration debounceTimeout = Duration(milliseconds: 300);
  static const Duration connectionTimeout = Duration(seconds: 10);

  // Cache durations
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(minutes: 30);
  static const Duration longCacheDuration = Duration(hours: 1);

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;

  // Player positions
  static const List<String> playerPositions = [
    'Goalkeeper',
    'Defender',
    'Midfielder',
    'Forward',
  ];

  // Match statuses
  static const List<String> matchStatuses = [
    'Scheduled',
    'Live',
    'Finished',
    'Postponed',
    'Cancelled',
  ];

  // Competition systems
  static const List<String> competitionSystems = [
    'League',
    'Groups',
    'Knockout',
    'Mixed',
  ];
}

class AppDimensions {
  // Icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Border radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;

  // Spacing
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
}
