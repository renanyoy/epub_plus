enum EpubState {
  broken,
  missingChapters,
  spineChapters,
  missingCover,
}

extension EpubStateExt on Set<EpubState> {
  bool get complete => isEmpty;
  bool get incomplete => isNotEmpty && !contains(EpubState.broken);
  bool get broken => contains(EpubState.broken);
}

class EpubStateResult {
  final Set<EpubState> state;
  final List<EpubError> errors;
  const EpubStateResult({this.state = const {}, this.errors = const []});
  @override
  String toString() => 'state: $state errors: ${errors.messages}';
  String debugInfo() => 'state: $state\r\n${errors.debugInfo}';
}

class EpubStateCollection {
  final Set<EpubState> state;
  final List<EpubError> errors;
  EpubStateCollection({
    Set<EpubState> state = const {},
    List<EpubError> errors = const [],
  })  : state = {...state},
        errors = [...errors];
  void add({Set<EpubState>? state, EpubError? error}) {
    this.state.addAll(state ?? const {});
    if (error != null) errors.add(error);
  }

  EpubStateResult get result => EpubStateResult(state: state, errors: errors);
  EpubReturnValue<T> returns<T>(T value) => EpubReturnValue<T>(value: value);
  T? combine<T>(EpubReturnValue<T> returnValue) {
    errors.addAll(returnValue.errors);
    state.addAll(returnValue.state);
    return returnValue.value;
  }

  @override
  String toString() => 'state: $state errors: ${errors.messages}';
  String debugInfo() => 'state: $state\r\n${errors.debugInfo}';
}

class EpubReturnValue<T> extends EpubStateCollection {
  T? value;
  EpubReturnValue(
      {this.value, super.state = const {}, super.errors = const []});
  @override
  String toString() => 'value: $value state: $state errors: ${errors.messages}';
  @override
  String debugInfo() => 'value:$value state: $state\r\n${errors.debugInfo}';
}

class EpubError extends Error {
  final String message;
  final StackTrace? exceptionTrace;
  EpubError({
    required this.message,
    this.exceptionTrace,
  });

  @override
  String toString() =>
      'EpubError(message: $message, exceptionTrace: $exceptionTrace, stackTrace: $stackTrace)';
}

extension EpubStateErrorExt on Iterable<EpubError> {
  String get debugInfo {
    final sb = StringBuffer();
    for (final e in this) {
      sb.writeln('=message==================================');
      sb.writeln(e.message);
      sb.writeln('-trace------------------------------------');
      sb.writeln(e.stackTrace);
      if (e.exceptionTrace != null) {
        sb.writeln('-exception--------------------------------');
        sb.writeln(e.exceptionTrace);
      }
    }
    if (isNotEmpty) sb.writeln('==========================================');
    return sb.toString();
  }

  String get messages {
    final sb = StringBuffer();
    if (isNotEmpty) sb.writeln('==========================================');
    for (final e in this) {
      sb.writeln(e.message);
    }
    if (isNotEmpty) sb.writeln('==========================================');
    return sb.toString();
  }
}

class EpubStateException {
  final String message;
  final Error? exception;
  final Iterable<EpubError> stateErrors;
  EpubStateException({
    required this.message,
    this.exception,
    this.stateErrors = const {},
  });
}
