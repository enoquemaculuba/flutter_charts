// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:charts_common_custom/charts_common_custom.dart' as common
    show ImmutableSeries, SelectionModel, SelectionModelType, SeriesDatumConfig;

/// Contains override settings for the internal chart state.
///
/// The chart will check non null settings and apply them if they differ from
/// the internal chart state and trigger the appropriate level of redrawing.
class UserManagedState<D> {
  /// The expected selection(s) on the chart.
  ///
  /// If this is set and the model for the selection model type differs from
  /// what is in the internal chart state, the selection will be applied and
  /// repainting will occur such that behaviors that draw differently on
  /// selection change can update, such as the line point highlighter.
  ///
  /// If more than one type of selection model is used, only the one(s)
  /// specified in this list will override what is kept in the internally.
  ///
  /// To clear the selection, add an empty selection model.
  final selectionModels =
      <common.SelectionModelType, UserManagedSelectionModel<D>>{};
}

/// Container for the user managed selection model.
///
/// This container is needed because the selection model generated by selection
/// events is a [SelectionModel], while any user defined selection has to be
/// specified by passing in [selectedSeriesConfig] and [selectedDataConfig].
/// The configuration is converted to a selection model after the series data
/// has been processed.
class UserManagedSelectionModel<D> {
  final List<String>? selectedSeriesConfig;
  final List<common.SeriesDatumConfig<D>>? selectedDataConfig;
  common.SelectionModel<D>? _model;

  /// Creates a [UserManagedSelectionModel] that holds [SelectionModel].
  ///
  /// [selectedSeriesConfig] and [selectedDataConfig] is set to null because the
  /// [_model] is returned when [getModel] is called.
  UserManagedSelectionModel({common.SelectionModel<D>? model})
      : _model = model ?? common.SelectionModel(),
        selectedSeriesConfig = null,
        selectedDataConfig = null;

  /// Creates a [UserManagedSelectionModel] with configuration that is converted
  /// to a [SelectionModel] when [getModel] provides a processed series list.
  UserManagedSelectionModel.fromConfig(
      {List<String>? selectedSeriesConfig,
      List<common.SeriesDatumConfig<D>>? selectedDataConfig})
      : this.selectedSeriesConfig = selectedSeriesConfig,
        this.selectedDataConfig = selectedDataConfig;

  /// Gets the selection model. If the model is null, create one from
  /// configuration and the processed [seriesList] passed in.
  common.SelectionModel<D> getModel(
      List<common.ImmutableSeries<D>> seriesList) {
    _model ??= common.SelectionModel<D>.fromConfig(
        selectedDataConfig, selectedSeriesConfig, seriesList);

    return _model!;
  }
}