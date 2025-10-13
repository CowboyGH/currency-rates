part of 'get_history_xml_cubit.dart';

/// Состояние экспорта истории.
sealed class GetHistoryXmlState extends Equatable {
  const GetHistoryXmlState();

  @override
  List<Object> get props => [];
}

/// Начальное состояние.
final class GetHistoryXmlInitial extends GetHistoryXmlState {
  const GetHistoryXmlInitial();
}

/// Состояние экспорта истории.
final class GetHistoryXmlLoading extends GetHistoryXmlState {
  const GetHistoryXmlLoading();
}

/// Состояние успешного экспорта истории.
final class GetHistoryXmlSuccess extends GetHistoryXmlState {
  final String xmlString;
  const GetHistoryXmlSuccess(this.xmlString);

  @override
  List<Object> get props => [xmlString];
}

/// Состояние ошибки экспорта истории.
final class GetHistoryXmlFailure extends GetHistoryXmlState {
  final AppFailure failure;

  const GetHistoryXmlFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
