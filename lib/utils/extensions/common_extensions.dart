extension $KotlinStyleExtension<T> on T {
  @pragma("vm:prefer-inline")
  T let(void Function(T it) func) {
    func(this);
    return this;
  }

  @pragma("vm:prefer-inline")
  T apply(void Function() func) {
    func();
    return this;
  }

  @pragma("vm:prefer-inline")
  R also<R>(R Function(T it) func) {
    return func(this);
  }

  @pragma("vm:prefer-inline")
  R run<R>(R Function() func) {
    return func();
  }
}
