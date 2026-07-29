import 'package:cloud_firestore/cloud_firestore.dart';

/// Converts Firestore field values to JSON-safe types for model parsing.
Map<String, dynamic> firestoreToJson(Map<String, dynamic> data) {
  return data.map((key, value) {
    if (value is Timestamp) {
      return MapEntry(key, value.toDate().toIso8601String());
    }
    if (value is List) {
      return MapEntry(
        key,
        value.map((item) {
          if (item is Map<String, dynamic>) {
            return firestoreToJson(item);
          }
          return item;
        }).toList(),
      );
    }
    if (value is Map<String, dynamic>) {
      return MapEntry(key, firestoreToJson(value));
    }
    return MapEntry(key, value);
  });
}

/// Converts model JSON to Firestore-compatible field values.
Map<String, dynamic> jsonToFirestore(Map<String, dynamic> data) {
  return data.map((key, value) {
    if (value is String && _isIsoDate(value)) {
      return MapEntry(key, Timestamp.fromDate(DateTime.parse(value)));
    }
    if (value is List) {
      return MapEntry(
        key,
        value.map((item) {
          if (item is Map<String, dynamic>) {
            return jsonToFirestore(item);
          }
          try {
            final json = (item as dynamic).toJson();
            if (json is Map<String, dynamic>) {
              return jsonToFirestore(json);
            }
          } catch (_) {}
          return item;
        }).toList(),
      );
    }
    if (value is Map<String, dynamic>) {
      return MapEntry(key, jsonToFirestore(value));
    }
    try {
      final json = (value as dynamic).toJson();
      if (json is Map<String, dynamic>) {
        return MapEntry(key, jsonToFirestore(json));
      }
    } catch (_) {}
    return MapEntry(key, value);
  });
}

bool _isIsoDate(String value) {
  return RegExp(r'^\d{4}-\d{2}-\d{2}T').hasMatch(value);
}

DocumentSnapshot<Map<String, dynamic>> docWithId(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  return doc;
}

Map<String, dynamic> docDataWithId(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = Map<String, dynamic>.from(doc.data() ?? {});
  data['id'] = doc.id;
  return firestoreToJson(data);
}
