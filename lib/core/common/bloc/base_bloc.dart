import '../uistate/common_ui_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<T> extends Cubit<CommonUIState<T>> {
  BaseBloc(CommonUIState state) : super(state);
}
