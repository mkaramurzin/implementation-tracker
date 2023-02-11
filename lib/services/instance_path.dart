class InstancePath {
  String? path;

  static final InstancePath _inst = InstancePath._internal();

  InstancePath._internal();

  factory InstancePath({required String path}) {
    _inst.path ??= path;
    return _inst;
  }
}