abstract class KeyValueStorageService {
  Future<void> setKeyvalue<T>(String key, T value);

  Future<T?> getValue<T>(String key);

  Future<bool> removeKey(String key);
}
