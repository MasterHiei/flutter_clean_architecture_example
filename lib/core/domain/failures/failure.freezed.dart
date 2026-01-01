// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure()';
}


}

/// @nodoc
class $FailureCopyWith<$Res>  {
$FailureCopyWith(Failure _, $Res Function(Failure) __);
}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkFailure value)?  network,TResult Function( ServerFailure value)?  server,TResult Function( CacheFailure value)?  cache,TResult Function( NotFoundFailure value)?  notFound,TResult Function( _ValidationFailure value)?  validation,TResult Function( DeviceFailure value)?  device,TResult Function( UnauthorizedFailure value)?  unauthorized,TResult Function( UnexpectedFailure value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case ServerFailure() when server != null:
return server(_that);case CacheFailure() when cache != null:
return cache(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case _ValidationFailure() when validation != null:
return validation(_that);case DeviceFailure() when device != null:
return device(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkFailure value)  network,required TResult Function( ServerFailure value)  server,required TResult Function( CacheFailure value)  cache,required TResult Function( NotFoundFailure value)  notFound,required TResult Function( _ValidationFailure value)  validation,required TResult Function( DeviceFailure value)  device,required TResult Function( UnauthorizedFailure value)  unauthorized,required TResult Function( UnexpectedFailure value)  unexpected,}){
final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that);case ServerFailure():
return server(_that);case CacheFailure():
return cache(_that);case NotFoundFailure():
return notFound(_that);case _ValidationFailure():
return validation(_that);case DeviceFailure():
return device(_that);case UnauthorizedFailure():
return unauthorized(_that);case UnexpectedFailure():
return unexpected(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkFailure value)?  network,TResult? Function( ServerFailure value)?  server,TResult? Function( CacheFailure value)?  cache,TResult? Function( NotFoundFailure value)?  notFound,TResult? Function( _ValidationFailure value)?  validation,TResult? Function( DeviceFailure value)?  device,TResult? Function( UnauthorizedFailure value)?  unauthorized,TResult? Function( UnexpectedFailure value)?  unexpected,}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case ServerFailure() when server != null:
return server(_that);case CacheFailure() when cache != null:
return cache(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case _ValidationFailure() when validation != null:
return validation(_that);case DeviceFailure() when device != null:
return device(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message)?  network,TResult Function( int? code,  String? message)?  server,TResult Function( String? message)?  cache,TResult Function( String resource)?  notFound,TResult Function( ValidationFailure details)?  validation,TResult Function( DeviceFailureReason reason)?  device,TResult Function( String? message)?  unauthorized,TResult Function( Object? error,  StackTrace? stackTrace)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.message);case ServerFailure() when server != null:
return server(_that.code,_that.message);case CacheFailure() when cache != null:
return cache(_that.message);case NotFoundFailure() when notFound != null:
return notFound(_that.resource);case _ValidationFailure() when validation != null:
return validation(_that.details);case DeviceFailure() when device != null:
return device(_that.reason);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.error,_that.stackTrace);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message)  network,required TResult Function( int? code,  String? message)  server,required TResult Function( String? message)  cache,required TResult Function( String resource)  notFound,required TResult Function( ValidationFailure details)  validation,required TResult Function( DeviceFailureReason reason)  device,required TResult Function( String? message)  unauthorized,required TResult Function( Object? error,  StackTrace? stackTrace)  unexpected,}) {final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that.message);case ServerFailure():
return server(_that.code,_that.message);case CacheFailure():
return cache(_that.message);case NotFoundFailure():
return notFound(_that.resource);case _ValidationFailure():
return validation(_that.details);case DeviceFailure():
return device(_that.reason);case UnauthorizedFailure():
return unauthorized(_that.message);case UnexpectedFailure():
return unexpected(_that.error,_that.stackTrace);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message)?  network,TResult? Function( int? code,  String? message)?  server,TResult? Function( String? message)?  cache,TResult? Function( String resource)?  notFound,TResult? Function( ValidationFailure details)?  validation,TResult? Function( DeviceFailureReason reason)?  device,TResult? Function( String? message)?  unauthorized,TResult? Function( Object? error,  StackTrace? stackTrace)?  unexpected,}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.message);case ServerFailure() when server != null:
return server(_that.code,_that.message);case CacheFailure() when cache != null:
return cache(_that.message);case NotFoundFailure() when notFound != null:
return notFound(_that.resource);case _ValidationFailure() when validation != null:
return validation(_that.details);case DeviceFailure() when device != null:
return device(_that.reason);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class NetworkFailure implements Failure {
  const NetworkFailure({this.message});
  

 final  String? message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.network(message: $message)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(NetworkFailure(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ServerFailure implements Failure {
  const ServerFailure({this.code, this.message});
  

 final  int? code;
 final  String? message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'Failure.server(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@useResult
$Res call({
 int? code, String? message
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? message = freezed,}) {
  return _then(ServerFailure(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class CacheFailure implements Failure {
  const CacheFailure({this.message});
  

 final  String? message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheFailureCopyWith<CacheFailure> get copyWith => _$CacheFailureCopyWithImpl<CacheFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.cache(message: $message)';
}


}

/// @nodoc
abstract mixin class $CacheFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $CacheFailureCopyWith(CacheFailure value, $Res Function(CacheFailure) _then) = _$CacheFailureCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$CacheFailureCopyWithImpl<$Res>
    implements $CacheFailureCopyWith<$Res> {
  _$CacheFailureCopyWithImpl(this._self, this._then);

  final CacheFailure _self;
  final $Res Function(CacheFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(CacheFailure(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class NotFoundFailure implements Failure {
  const NotFoundFailure({required this.resource});
  

 final  String resource;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotFoundFailureCopyWith<NotFoundFailure> get copyWith => _$NotFoundFailureCopyWithImpl<NotFoundFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundFailure&&(identical(other.resource, resource) || other.resource == resource));
}


@override
int get hashCode => Object.hash(runtimeType,resource);

@override
String toString() {
  return 'Failure.notFound(resource: $resource)';
}


}

/// @nodoc
abstract mixin class $NotFoundFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NotFoundFailureCopyWith(NotFoundFailure value, $Res Function(NotFoundFailure) _then) = _$NotFoundFailureCopyWithImpl;
@useResult
$Res call({
 String resource
});




}
/// @nodoc
class _$NotFoundFailureCopyWithImpl<$Res>
    implements $NotFoundFailureCopyWith<$Res> {
  _$NotFoundFailureCopyWithImpl(this._self, this._then);

  final NotFoundFailure _self;
  final $Res Function(NotFoundFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? resource = null,}) {
  return _then(NotFoundFailure(
resource: null == resource ? _self.resource : resource // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ValidationFailure implements Failure {
  const _ValidationFailure(this.details);
  

 final  ValidationFailure details;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValidationFailureCopyWith<_ValidationFailure> get copyWith => __$ValidationFailureCopyWithImpl<_ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ValidationFailure&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,details);

@override
String toString() {
  return 'Failure.validation(details: $details)';
}


}

/// @nodoc
abstract mixin class _$ValidationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory _$ValidationFailureCopyWith(_ValidationFailure value, $Res Function(_ValidationFailure) _then) = __$ValidationFailureCopyWithImpl;
@useResult
$Res call({
 ValidationFailure details
});


$ValidationFailureCopyWith<$Res> get details;

}
/// @nodoc
class __$ValidationFailureCopyWithImpl<$Res>
    implements _$ValidationFailureCopyWith<$Res> {
  __$ValidationFailureCopyWithImpl(this._self, this._then);

  final _ValidationFailure _self;
  final $Res Function(_ValidationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? details = null,}) {
  return _then(_ValidationFailure(
null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as ValidationFailure,
  ));
}

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<$Res> get details {
  
  return $ValidationFailureCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

/// @nodoc


class DeviceFailure implements Failure {
  const DeviceFailure({required this.reason});
  

 final  DeviceFailureReason reason;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceFailureCopyWith<DeviceFailure> get copyWith => _$DeviceFailureCopyWithImpl<DeviceFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceFailure&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'Failure.device(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $DeviceFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $DeviceFailureCopyWith(DeviceFailure value, $Res Function(DeviceFailure) _then) = _$DeviceFailureCopyWithImpl;
@useResult
$Res call({
 DeviceFailureReason reason
});




}
/// @nodoc
class _$DeviceFailureCopyWithImpl<$Res>
    implements $DeviceFailureCopyWith<$Res> {
  _$DeviceFailureCopyWithImpl(this._self, this._then);

  final DeviceFailure _self;
  final $Res Function(DeviceFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(DeviceFailure(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as DeviceFailureReason,
  ));
}


}

/// @nodoc


class UnauthorizedFailure implements Failure {
  const UnauthorizedFailure({this.message});
  

 final  String? message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthorizedFailureCopyWith<UnauthorizedFailure> get copyWith => _$UnauthorizedFailureCopyWithImpl<UnauthorizedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.unauthorized(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnauthorizedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnauthorizedFailureCopyWith(UnauthorizedFailure value, $Res Function(UnauthorizedFailure) _then) = _$UnauthorizedFailureCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$UnauthorizedFailureCopyWithImpl<$Res>
    implements $UnauthorizedFailureCopyWith<$Res> {
  _$UnauthorizedFailureCopyWithImpl(this._self, this._then);

  final UnauthorizedFailure _self;
  final $Res Function(UnauthorizedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(UnauthorizedFailure(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnexpectedFailure implements Failure {
  const UnexpectedFailure({this.error, this.stackTrace});
  

 final  Object? error;
 final  StackTrace? stackTrace;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedFailureCopyWith<UnexpectedFailure> get copyWith => _$UnexpectedFailureCopyWithImpl<UnexpectedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedFailure&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'Failure.unexpected(error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $UnexpectedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnexpectedFailureCopyWith(UnexpectedFailure value, $Res Function(UnexpectedFailure) _then) = _$UnexpectedFailureCopyWithImpl;
@useResult
$Res call({
 Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class _$UnexpectedFailureCopyWithImpl<$Res>
    implements $UnexpectedFailureCopyWith<$Res> {
  _$UnexpectedFailureCopyWithImpl(this._self, this._then);

  final UnexpectedFailure _self;
  final $Res Function(UnexpectedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(UnexpectedFailure(
error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc
mixin _$ValidationFailure {

 String get field;
/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this as ValidationFailure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&(identical(other.field, field) || other.field == field));
}


@override
int get hashCode => Object.hash(runtimeType,field);

@override
String toString() {
  return 'ValidationFailure(field: $field)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res>  {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@useResult
$Res call({
 String field
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ValidationFailure].
extension ValidationFailurePatterns on ValidationFailure {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EmptyFieldFailure value)?  emptyField,TResult Function( InvalidFormatFailure value)?  invalidFormat,TResult Function( TooShortFailure value)?  tooShort,TResult Function( TooLongFailure value)?  tooLong,TResult Function( MismatchFailure value)?  mismatch,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EmptyFieldFailure() when emptyField != null:
return emptyField(_that);case InvalidFormatFailure() when invalidFormat != null:
return invalidFormat(_that);case TooShortFailure() when tooShort != null:
return tooShort(_that);case TooLongFailure() when tooLong != null:
return tooLong(_that);case MismatchFailure() when mismatch != null:
return mismatch(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EmptyFieldFailure value)  emptyField,required TResult Function( InvalidFormatFailure value)  invalidFormat,required TResult Function( TooShortFailure value)  tooShort,required TResult Function( TooLongFailure value)  tooLong,required TResult Function( MismatchFailure value)  mismatch,}){
final _that = this;
switch (_that) {
case EmptyFieldFailure():
return emptyField(_that);case InvalidFormatFailure():
return invalidFormat(_that);case TooShortFailure():
return tooShort(_that);case TooLongFailure():
return tooLong(_that);case MismatchFailure():
return mismatch(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EmptyFieldFailure value)?  emptyField,TResult? Function( InvalidFormatFailure value)?  invalidFormat,TResult? Function( TooShortFailure value)?  tooShort,TResult? Function( TooLongFailure value)?  tooLong,TResult? Function( MismatchFailure value)?  mismatch,}){
final _that = this;
switch (_that) {
case EmptyFieldFailure() when emptyField != null:
return emptyField(_that);case InvalidFormatFailure() when invalidFormat != null:
return invalidFormat(_that);case TooShortFailure() when tooShort != null:
return tooShort(_that);case TooLongFailure() when tooLong != null:
return tooLong(_that);case MismatchFailure() when mismatch != null:
return mismatch(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String field)?  emptyField,TResult Function( String field)?  invalidFormat,TResult Function( String field,  int min)?  tooShort,TResult Function( String field,  int max)?  tooLong,TResult Function( String field)?  mismatch,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EmptyFieldFailure() when emptyField != null:
return emptyField(_that.field);case InvalidFormatFailure() when invalidFormat != null:
return invalidFormat(_that.field);case TooShortFailure() when tooShort != null:
return tooShort(_that.field,_that.min);case TooLongFailure() when tooLong != null:
return tooLong(_that.field,_that.max);case MismatchFailure() when mismatch != null:
return mismatch(_that.field);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String field)  emptyField,required TResult Function( String field)  invalidFormat,required TResult Function( String field,  int min)  tooShort,required TResult Function( String field,  int max)  tooLong,required TResult Function( String field)  mismatch,}) {final _that = this;
switch (_that) {
case EmptyFieldFailure():
return emptyField(_that.field);case InvalidFormatFailure():
return invalidFormat(_that.field);case TooShortFailure():
return tooShort(_that.field,_that.min);case TooLongFailure():
return tooLong(_that.field,_that.max);case MismatchFailure():
return mismatch(_that.field);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String field)?  emptyField,TResult? Function( String field)?  invalidFormat,TResult? Function( String field,  int min)?  tooShort,TResult? Function( String field,  int max)?  tooLong,TResult? Function( String field)?  mismatch,}) {final _that = this;
switch (_that) {
case EmptyFieldFailure() when emptyField != null:
return emptyField(_that.field);case InvalidFormatFailure() when invalidFormat != null:
return invalidFormat(_that.field);case TooShortFailure() when tooShort != null:
return tooShort(_that.field,_that.min);case TooLongFailure() when tooLong != null:
return tooLong(_that.field,_that.max);case MismatchFailure() when mismatch != null:
return mismatch(_that.field);case _:
  return null;

}
}

}

/// @nodoc


class EmptyFieldFailure implements ValidationFailure {
  const EmptyFieldFailure(this.field);
  

@override final  String field;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmptyFieldFailureCopyWith<EmptyFieldFailure> get copyWith => _$EmptyFieldFailureCopyWithImpl<EmptyFieldFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyFieldFailure&&(identical(other.field, field) || other.field == field));
}


@override
int get hashCode => Object.hash(runtimeType,field);

@override
String toString() {
  return 'ValidationFailure.emptyField(field: $field)';
}


}

/// @nodoc
abstract mixin class $EmptyFieldFailureCopyWith<$Res> implements $ValidationFailureCopyWith<$Res> {
  factory $EmptyFieldFailureCopyWith(EmptyFieldFailure value, $Res Function(EmptyFieldFailure) _then) = _$EmptyFieldFailureCopyWithImpl;
@override @useResult
$Res call({
 String field
});




}
/// @nodoc
class _$EmptyFieldFailureCopyWithImpl<$Res>
    implements $EmptyFieldFailureCopyWith<$Res> {
  _$EmptyFieldFailureCopyWithImpl(this._self, this._then);

  final EmptyFieldFailure _self;
  final $Res Function(EmptyFieldFailure) _then;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,}) {
  return _then(EmptyFieldFailure(
null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class InvalidFormatFailure implements ValidationFailure {
  const InvalidFormatFailure(this.field);
  

@override final  String field;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvalidFormatFailureCopyWith<InvalidFormatFailure> get copyWith => _$InvalidFormatFailureCopyWithImpl<InvalidFormatFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidFormatFailure&&(identical(other.field, field) || other.field == field));
}


@override
int get hashCode => Object.hash(runtimeType,field);

@override
String toString() {
  return 'ValidationFailure.invalidFormat(field: $field)';
}


}

/// @nodoc
abstract mixin class $InvalidFormatFailureCopyWith<$Res> implements $ValidationFailureCopyWith<$Res> {
  factory $InvalidFormatFailureCopyWith(InvalidFormatFailure value, $Res Function(InvalidFormatFailure) _then) = _$InvalidFormatFailureCopyWithImpl;
@override @useResult
$Res call({
 String field
});




}
/// @nodoc
class _$InvalidFormatFailureCopyWithImpl<$Res>
    implements $InvalidFormatFailureCopyWith<$Res> {
  _$InvalidFormatFailureCopyWithImpl(this._self, this._then);

  final InvalidFormatFailure _self;
  final $Res Function(InvalidFormatFailure) _then;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,}) {
  return _then(InvalidFormatFailure(
null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TooShortFailure implements ValidationFailure {
  const TooShortFailure(this.field, {required this.min});
  

@override final  String field;
 final  int min;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooShortFailureCopyWith<TooShortFailure> get copyWith => _$TooShortFailureCopyWithImpl<TooShortFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooShortFailure&&(identical(other.field, field) || other.field == field)&&(identical(other.min, min) || other.min == min));
}


@override
int get hashCode => Object.hash(runtimeType,field,min);

@override
String toString() {
  return 'ValidationFailure.tooShort(field: $field, min: $min)';
}


}

/// @nodoc
abstract mixin class $TooShortFailureCopyWith<$Res> implements $ValidationFailureCopyWith<$Res> {
  factory $TooShortFailureCopyWith(TooShortFailure value, $Res Function(TooShortFailure) _then) = _$TooShortFailureCopyWithImpl;
@override @useResult
$Res call({
 String field, int min
});




}
/// @nodoc
class _$TooShortFailureCopyWithImpl<$Res>
    implements $TooShortFailureCopyWith<$Res> {
  _$TooShortFailureCopyWithImpl(this._self, this._then);

  final TooShortFailure _self;
  final $Res Function(TooShortFailure) _then;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? min = null,}) {
  return _then(TooShortFailure(
null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TooLongFailure implements ValidationFailure {
  const TooLongFailure(this.field, {required this.max});
  

@override final  String field;
 final  int max;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooLongFailureCopyWith<TooLongFailure> get copyWith => _$TooLongFailureCopyWithImpl<TooLongFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooLongFailure&&(identical(other.field, field) || other.field == field)&&(identical(other.max, max) || other.max == max));
}


@override
int get hashCode => Object.hash(runtimeType,field,max);

@override
String toString() {
  return 'ValidationFailure.tooLong(field: $field, max: $max)';
}


}

/// @nodoc
abstract mixin class $TooLongFailureCopyWith<$Res> implements $ValidationFailureCopyWith<$Res> {
  factory $TooLongFailureCopyWith(TooLongFailure value, $Res Function(TooLongFailure) _then) = _$TooLongFailureCopyWithImpl;
@override @useResult
$Res call({
 String field, int max
});




}
/// @nodoc
class _$TooLongFailureCopyWithImpl<$Res>
    implements $TooLongFailureCopyWith<$Res> {
  _$TooLongFailureCopyWithImpl(this._self, this._then);

  final TooLongFailure _self;
  final $Res Function(TooLongFailure) _then;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? max = null,}) {
  return _then(TooLongFailure(
null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MismatchFailure implements ValidationFailure {
  const MismatchFailure(this.field);
  

@override final  String field;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MismatchFailureCopyWith<MismatchFailure> get copyWith => _$MismatchFailureCopyWithImpl<MismatchFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MismatchFailure&&(identical(other.field, field) || other.field == field));
}


@override
int get hashCode => Object.hash(runtimeType,field);

@override
String toString() {
  return 'ValidationFailure.mismatch(field: $field)';
}


}

/// @nodoc
abstract mixin class $MismatchFailureCopyWith<$Res> implements $ValidationFailureCopyWith<$Res> {
  factory $MismatchFailureCopyWith(MismatchFailure value, $Res Function(MismatchFailure) _then) = _$MismatchFailureCopyWithImpl;
@override @useResult
$Res call({
 String field
});




}
/// @nodoc
class _$MismatchFailureCopyWithImpl<$Res>
    implements $MismatchFailureCopyWith<$Res> {
  _$MismatchFailureCopyWithImpl(this._self, this._then);

  final MismatchFailure _self;
  final $Res Function(MismatchFailure) _then;

/// Create a copy of ValidationFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,}) {
  return _then(MismatchFailure(
null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
