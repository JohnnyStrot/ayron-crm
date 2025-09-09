import 'package:ayron_crm/data/model/song.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/core/ui/durationpicker.dart';
import 'package:ayron_crm/ui/details/details_view.dart';
import 'package:ayron_crm/ui/song/song_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SongDetails extends DetailsView<Song, SongDetails, SongDetailsViewmodel> {
  const SongDetails({super.key, required super.viewmodel});

  @override
  State<SongDetails> createState() => _SongDetailsState();
}

class _SongDetailsState
    extends DetailsState<Song, SongDetails, SongDetailsViewmodel> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewmodel.createEntity,
        widget.viewmodel.loadEntity,
        widget.viewmodel.saveEntity,
      ]),
      builder: (context, _) {
        final song = widget.viewmodel.entity;
        if (song != null) {
          return Form(
            key: formKey,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: submit,
                child: Icon(Icons.save),
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.of(context).paddingScreenVertical,
                  horizontal: Dimens.of(context).paddingScreenHorizontal,
                ),
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Song ",
                          style: TextStyle(fontWeight: FontWeight.w200),
                        ),
                        TextSpan(
                          text: song.name.isEmpty ? "#${song.id}" : song.name,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      style: TextTheme.of(context).headlineSmall!.copyWith(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Switch(
                        value: song.inRepertoire,
                        onChanged: (value) => setState(() {
                          song.inRepertoire = value;
                        }),
                      ),
                      Text("Im Repertoire"),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  TextFormField(
                    validator: (value) => value == null || (value.length <= 72)
                        ? null
                        : "Max. 72 Zeichen",
                    decoration: InputDecoration(
                      filled: true,
                      label: Text("Name"),
                      border: UnderlineInputBorder(),
                    ),
                    controller: TextEditingController(text: song.name),
                    onChanged: (value) => song.name = value,
                  ),
                  SizedBox(height: Dimens.vdivide),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(text: song.author),
                          onChanged: (value) => song.author = value,
                          decoration: InputDecoration(label: Text("Urheber")),
                          validator: (value) =>
                              value == null || (value.length <= 72)
                              ? null
                              : "Max. 72 Zeichen",
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(text: song.youtube),
                          onChanged: (value) => song.youtube = value,
                          decoration: InputDecoration(label: Text("Tuning")),
                          validator: (value) =>
                              value == null || (value.length <= 128)
                              ? null
                              : "Max. 128 Zeichen",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(text: song.key),
                          onChanged: (value) => song.key = value,
                          decoration: InputDecoration(label: Text("Tonart")),
                          validator: (value) =>
                              value == null || (value.length <= 15)
                              ? null
                              : "Max. 15 Zeichen",
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(text: song.mood),
                          onChanged: (value) => song.mood = value,
                          decoration: InputDecoration(label: Text("Stimmung")),
                          validator: (value) =>
                              value == null || (value.length <= 72)
                              ? null
                              : "Max. 72 Zeichen",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: song.bpm == null ? "" : song.bpm.toString(),
                          ),
                          onChanged: (value) => song.bpm = int.tryParse(value),
                          decoration: InputDecoration(label: Text("BPM")),
                          validator: (value) =>
                              (value != null &&
                                  value.isNotEmpty &&
                                  int.tryParse(value) == null)
                              ? "Ungültige Zahl"
                              : null,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      Expanded(
                        child: DurationPicker(
                          onDuration: (v) => song.duration = v,
                          initialValue: song.duration,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.vdivide),
                  TextFormField(
                    controller: TextEditingController(text: song.lyrics),
                    onChanged: (value) => song.lyrics = value,
                    decoration: InputDecoration(label: Text("Lyrics")),
                    maxLines: 6,
                    minLines: 6,
                  ),
                  SizedBox(height: Dimens.vgap),
                  TextFormField(
                    controller: TextEditingController(
                      text: song.interpretation,
                    ),
                    onChanged: (value) => song.interpretation = value,
                    decoration: InputDecoration(label: Text("Interpretation")),
                    maxLines: 3,
                    minLines: 3,
                  ),
                  SizedBox(height: Dimens.vdivide),
                  Text("Public", style: TextTheme.of(context).headlineSmall),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Switch(
                        value: song.showOnWebsite,
                        onChanged: (value) => setState(() {
                          song.showOnWebsite = value;
                        }),
                      ),
                      Text("Zeige auf Website"),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(text: song.spotify),
                          onChanged: (value) => song.spotify = value,
                          decoration: InputDecoration(label: Text("Spotify")),
                          validator: (value) =>
                              value == null || (value.length <= 128)
                              ? null
                              : "Max. 128 Zeichen",
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(text: song.youtube),
                          onChanged: (value) => song.youtube = value,
                          decoration: InputDecoration(label: Text("YouTube")),
                          validator: (value) =>
                              value == null || (value.length <= 128)
                              ? null
                              : "Max. 128 Zeichen",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: song.applemusic,
                          ),
                          onChanged: (value) => song.applemusic = value,
                          decoration: InputDecoration(
                            label: Text("Apple Music"),
                          ),
                          validator: (value) =>
                              value == null || (value.length <= 128)
                              ? null
                              : "Max. 128 Zeichen",
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(text: song.ytmusic),
                          onChanged: (value) => song.ytmusic = value,
                          decoration: InputDecoration(
                            label: Text("YouTube Music"),
                          ),
                          validator: (value) =>
                              value == null || (value.length <= 128)
                              ? null
                              : "Max. 128 Zeichen",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.vgap),
                  Row(
                    spacing: Dimens.hgap,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: song.amazonmusic,
                          ),
                          onChanged: (value) => song.amazonmusic = value,
                          decoration: InputDecoration(
                            label: Text("Amazon Music"),
                          ),
                          validator: (value) =>
                              value == null || (value.length <= 128)
                              ? null
                              : "Max. 128 Zeichen",
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(height: Dimens.vdivide),
                  TextFormField(
                    controller: TextEditingController(text: song.publicText),
                    onChanged: (value) => song.publicText = value,
                    decoration: InputDecoration(
                      label: Text("Text für Website"),
                    ),
                    maxLines: 3,
                    minLines: 3,
                  ),
                  SizedBox(height: Dimens.fabGap),
                ],
              ),
            ),
          );
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  @override
  String get typeDisplay => "Song";
}
