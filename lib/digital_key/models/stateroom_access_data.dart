import 'package:flutter/material.dart';

enum AccessMethod { mobileApp }

enum AccessStatus { locked, unlocked, accessGranted, accessDenied }

class Guest {
  const Guest({
    required this.id,
    required this.name,
    required this.stateroomNumber,
    required this.deckNumber,
    this.profileImage,
  });

  final String id;
  final String name;
  final String stateroomNumber;
  final String deckNumber;
  final String? profileImage;
}

class StateroomAccess {
  const StateroomAccess({
    required this.stateroomNumber,
    required this.deckNumber,
    required this.guest,
    required this.accessStatus,
    required this.lastAccessTime,
    required this.accessMethod,
    this.location,
    this.notes,
  });

  final String stateroomNumber;
  final String deckNumber;
  final Guest guest;
  final AccessStatus accessStatus;
  final DateTime lastAccessTime;
  final AccessMethod accessMethod;
  final String? location;
  final String? notes;
}

class AccessLog {
  const AccessLog({
    required this.timestamp,
    required this.guestId,
    required this.stateroomNumber,
    required this.accessMethod,
    required this.accessStatus,
    required this.location,
  });

  final DateTime timestamp;
  final String guestId;
  final String stateroomNumber;
  final AccessMethod accessMethod;
  final AccessStatus accessStatus;
  final String location;
}

class StateroomAccessData {
  static Guest getCurrentGuest() {
    return const Guest(
      id: 'guest_001',
      name: 'John Smith',
      stateroomNumber: '8501',
      deckNumber: '8',
      profileImage: 'assets/images/guest_profile_1.jpg',
    );
  }

  static StateroomAccess getCurrentStateroomAccess() {
    return StateroomAccess(
      stateroomNumber: '8501',
      deckNumber: '8',
      guest: getCurrentGuest(),
      accessStatus: AccessStatus.locked,
      lastAccessTime: DateTime.now().subtract(const Duration(hours: 2)),
      accessMethod: AccessMethod.mobileApp,
      location: 'Deck 8 Forward',
      notes: 'Balcony stateroom with ocean view',
    );
  }

  static List<AccessLog> getRecentAccessLogs() {
    return [
      AccessLog(
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        guestId: 'guest_001',
        stateroomNumber: '8501',
        accessMethod: AccessMethod.mobileApp,
        accessStatus: AccessStatus.accessGranted,
        location: 'Deck 8 Forward',
      ),
      AccessLog(
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        guestId: 'guest_001',
        stateroomNumber: '8501',
        accessMethod: AccessMethod.mobileApp,
        accessStatus: AccessStatus.accessGranted,
        location: 'Deck 8 Forward',
      ),
      AccessLog(
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        guestId: 'guest_001',
        stateroomNumber: '8501',
        accessMethod: AccessMethod.mobileApp,
        accessStatus: AccessStatus.accessDenied,
        location: 'Deck 8 Forward',
      ),
      AccessLog(
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        guestId: 'guest_001',
        stateroomNumber: '8501',
        accessMethod: AccessMethod.mobileApp,
        accessStatus: AccessStatus.accessGranted,
        location: 'Deck 8 Forward',
      ),
    ];
  }

  static String getAccessMethodDisplayName(AccessMethod method) {
    switch (method) {
      case AccessMethod.mobileApp:
        return 'Mobile App';
    }
  }

  static IconData getAccessMethodIcon(AccessMethod method) {
    switch (method) {
      case AccessMethod.mobileApp:
        return Icons.phone_android;
    }
  }

  static Color getAccessStatusColor(AccessStatus status) {
    switch (status) {
      case AccessStatus.locked:
        return Colors.red;
      case AccessStatus.unlocked:
        return Colors.orange;
      case AccessStatus.accessGranted:
        return Colors.green;
      case AccessStatus.accessDenied:
        return Colors.red;
    }
  }

  static String getAccessStatusDisplayName(AccessStatus status) {
    switch (status) {
      case AccessStatus.locked:
        return 'Locked';
      case AccessStatus.unlocked:
        return 'Unlocked';
      case AccessStatus.accessGranted:
        return 'Access Granted';
      case AccessStatus.accessDenied:
        return 'Access Denied';
    }
  }
}
