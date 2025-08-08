import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/location/location_details_viewmodel.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter/material.dart';

class LocationDetails extends StatefulWidget {
  const LocationDetails({
    super.key,
    required LocationDetailsViewmodel viewmodel,
  }) : _viewmodel = viewmodel;

  final LocationDetailsViewmodel _viewmodel;

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget._viewmodel.saveLocation.addListener(_onSaved);
  }

  @override
  void didUpdateWidget(covariant LocationDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget._viewmodel.saveLocation.removeListener(_onSaved);
    widget._viewmodel.saveLocation.addListener(_onSaved);
  }

  @override
  void dispose() {
    widget._viewmodel.saveLocation.removeListener(_onSaved);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimens.of(context).paddingScreenVertical,
        horizontal: Dimens.of(context).paddingScreenHorizontal,
      ),
      child: ListenableBuilder(
        listenable: Listenable.merge([
          widget._viewmodel.createLocation,
          widget._viewmodel.loadLocation,
        ]),
        builder: (context, _) {
          final location = widget._viewmodel.location;
          if (location != null) {
            return Form(
              key: _formKey,
              child: Column(
                spacing: Dimens.vgap,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Location #${location.id}",
                    style: TextTheme.of(context).headlineSmall,
                  ),
                  TextFormField(
                    validator: (value) => value == null || (value.length <= 142)
                        ? null
                        : "Name darf nur 142 Zeichen lang sein.",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Name"),
                    ),
                    controller: TextEditingController(text: location.name),
                    onChanged: (value) => widget._viewmodel.setName(value),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        widget._viewmodel.saveLocation.execute();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }

  void _onSaved() {
    if (!widget._viewmodel.saveLocation.isExecuting.value) {
      switch (widget._viewmodel.saveLocation.value) {
        case Ok<void>():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Location gespeichert")));
        case Error<void>():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Location konnte nicht gespeichert werden"),
              action: SnackBarAction(
                label: "Nochmal",
                onPressed: widget._viewmodel.saveLocation.execute,
              ),
            ),
          );
      }
    }
  }
}
