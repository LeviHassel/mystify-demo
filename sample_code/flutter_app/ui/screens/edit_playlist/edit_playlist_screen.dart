import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mystify/data/constants/icons/font_awesome_regular_icons.dart';
import 'package:mystify/generated/l10n.dart';
import 'package:mystify/ui/screens/edit_playlist/edit_playlist_vm.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/filters/add_filter_button.dart';
import 'package:mystify/ui/screens/edit_playlist/widgets/filters/filter_panels.dart';
import 'package:mystify/ui/shared/providers/stateful_provider.dart';
import 'package:mystify/ui/shared/utilities/dialog_utility.dart';
import 'package:mystify/ui/shared/utilities/flushbar_utility.dart';
import 'package:mystify/ui/shared/widgets/custom_back_button.dart';
import 'package:mystify/ui/shared/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class EditPlaylistScreen extends StatelessWidget {
  final String playlistId;
  EditPlaylistScreen({this.playlistId});

  @override
  Widget build(BuildContext context) {
    var userId = context.watch<FirebaseUser>().uid;

    return StatefulProvider<EditPlaylistVM>(
      init: (vm) => vm.init(playlistId),
      onChange: (vm) => vm.onChange(userId),
      builder: (context, vm, child) {
        return WillPopScope(
          onWillPop: () => _showEditPlaylistBackDialog(context, vm),
          child: vm.isBusy
              ? Scaffold(body: LoadingIndicator())
              : Scaffold(
                  appBar: _buildAppBar(context, vm),
                  body: GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusNode()),
                    child: _buildForm(context, vm),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, EditPlaylistVM vm) {
    return AppBar(
      leading: CustomBackButton(),
      title: Text(
        vm.isEditing
            ? MystifyLocalizations.of(context).editPlaylist
            : MystifyLocalizations.of(context).addPlaylist,
        style: Theme.of(context).primaryTextTheme.headline6,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(FontAwesomeRegular.check_circle),
          onPressed: () => _onSave(context, vm),
        )
      ],
    );
  }

  Widget _buildForm(BuildContext context, EditPlaylistVM vm) {
    return Form(
      key: vm.formKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 10.0),
          _buildTitleTextField(context, vm),
          SizedBox(height: 20.0),
          _buildDescriptionTextField(context, vm),
          SizedBox(height: 20.0),
          Text(
            MystifyLocalizations.of(context).filters,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 5.0),
          FilterPanels(),
          SizedBox(height: 5.0),
          AddFilterButton(vm.addFilter),
        ],
      ),
    );
  }

  Widget _buildTitleTextField(BuildContext context, EditPlaylistVM vm) {
    return TextFormField(
      controller: vm.titleController,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: MystifyLocalizations.of(context).title,
        labelStyle: Theme.of(context).accentTextTheme.headline6,
      ),
      maxLength: 100,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return MystifyLocalizations.of(context).titleValidation;
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionTextField(BuildContext context, EditPlaylistVM vm) {
    return TextFormField(
      controller: vm.descriptionController,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: MystifyLocalizations.of(context).description,
        labelStyle: Theme.of(context).accentTextTheme.headline6,
      ),
      maxLines: 5,
      maxLength: 300,
    );
  }

  Future<bool> _showEditPlaylistBackDialog(
      BuildContext context, EditPlaylistVM vm) async {
    return await DialogUtility.showConfirmationDialog(
          context: context,
          title: vm.isEditing
              ? MystifyLocalizations.of(context).discardChangesConfirmation
              : MystifyLocalizations.of(context).discardPlaylistConfirmation,
          onPressed: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
          action: vm.isEditing
              ? MystifyLocalizations.of(context).discardChanges
              : MystifyLocalizations.of(context).discardPlaylist,
        ) ??
        false;
  }

  void _onSave(BuildContext context, EditPlaylistVM vm) async {
    if (vm.formKey.currentState.validate()) {
      var updatePlaylistSuccess = await vm.savePlaylist();

      if (updatePlaylistSuccess) {
        Navigator.pop(context);
      }

      FlushbarUtility.showResultFlushbar(
        context: context,
        success: updatePlaylistSuccess,
        successMessage: vm.playlist.isNew
            ? MystifyLocalizations.of(context)
                .createPlaylistSuccess(vm.playlist.title)
            : MystifyLocalizations.of(context)
                .updatePlaylistSuccess(vm.playlist.title),
        failureMessage: vm.playlist.isNew
            ? MystifyLocalizations.of(context)
                .createPlaylistFailure(vm.playlist.title)
            : MystifyLocalizations.of(context)
                .updatePlaylistFailure(vm.playlist.title),
      );

      if (updatePlaylistSuccess) {
        vm.syncPlaylist();
      }
    }
  }
}
