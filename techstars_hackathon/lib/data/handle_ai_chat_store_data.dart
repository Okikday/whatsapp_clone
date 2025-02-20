import 'package:google_generative_ai/src/content.dart';
import '../common/strings/hive_paths.dart';
import 'hive_data.dart';

class HandleAiChatStoreData {
  final String _userId;
  final String path;
  HandleAiChatStoreData(String userId) : _userId = userId, path = "${HivePaths.pathToChatStore}/{$userId}";

  static final HiveData _hiveData = HiveData();
  Future<void> updateUserChatStore({required List<Content> contentToStore}) async {
    List<Map<String, Object?>> finalContentToStore = [];
    for (int i = 0; i < contentToStore.length; i++) {
      finalContentToStore.add(contentToStore[i].toJson());
    }
    for (var value in finalContentToStore) {
      await _hiveData.appendToList(path, value);
    }
  }

  Future<void> addContentToChatStore(Content content) async{
    _hiveData.appendToList(path, content.toJson());
  }

  Future<List<Content>> getUserChatStore() async {
    final List? rawResult = (await _hiveData.getData(key: path)) as List?;
    if (rawResult == null) return [];

    return rawResult.map((value) => parseContent(Map<String, Object?>.from(value))).toList();
  }




  Stream<Content?> streamUserChatStoreContent() async* {
    await for (final value in _hiveData.streamData(path: path)) {
      if (value == null || (value is List && value.isEmpty)) {
        yield null;
        continue; // Skip emitting if the data is null or empty
      }
      for (final content in value) {
        yield parseContent(Map.from(content));
      }
    }
  }

  Future<void> deleteUserAllChatStore() async {
    await _hiveData.deleteData(key: path);
  }

}
