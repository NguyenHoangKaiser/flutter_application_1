part of 'post_cubit.dart';

@freezed
class PostState with _$PostState {
  const factory PostState.initial() = _Initial;
  const factory PostState.loading() = _Loading;
  const factory PostState.loaded(List<Post> post) = _Loader;
  const factory PostState.error() = _Error;
}
