import 'package:flutter/material.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/global/global.dart';
import '../../common/helper/dialog_helper.dart';
import '../../common/utils/utility_methods.dart';
import '../widgets/gradient_button.dart';
import '../widgets/my_country_state_city_picker.dart';

class ForcedSelectLocationScreen extends StatefulWidget {
  const ForcedSelectLocationScreen({super.key});

  @override
  State<ForcedSelectLocationScreen> createState() =>
      _ForcedSelectLocationScreenState();
}

class _ForcedSelectLocationScreenState
    extends State<ForcedSelectLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //It should be false to work
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _onBackPressed();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            StringConstants.selectLocation,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          children: const [
            SizedBox(height: 20.0),
            SelectLocationForm(),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  _onBackPressed() {
    DialogHelper.showErrorDialog(
      title: StringConstants.important,
      description: StringConstants.appDoesNotHaveLocationPermission,
    );
  }
}

class SelectLocationForm extends StatefulWidget {
  const SelectLocationForm({super.key});

  @override
  State<SelectLocationForm> createState() => _SelectLocationFormState();
}

class _SelectLocationFormState extends State<SelectLocationForm> {
  TextEditingController countryTEC = TextEditingController();
  TextEditingController stateTEC = TextEditingController();
  TextEditingController cityTEC = TextEditingController();

  String? _validateCountry(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.countryIsRequired;
    }
    return null;
  }

  String? _validateState(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.countryIsRequired;
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.countryIsRequired;
    }
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loadLocation();
    super.initState();
  }

  void loadLocation() {
    if (selectedLocation.country.value.isEmpty) {
      countryTEC.text = locationService.country.value;
      stateTEC.text = locationService.state.value;
      cityTEC.text = locationService.city.value;
    } else {
      countryTEC.text = selectedLocation.country.value;
      stateTEC.text = selectedLocation.state.value;
      cityTEC.text = selectedLocation.city.value;
    }
  }

  @override
  void dispose() {
    countryTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CountryStateCityPicker(
            country: countryTEC,
            countryValidator: _validateCountry,
            countryInputDecoration: InputDecoration(
              hintText: StringConstants.country,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.country,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
            state: stateTEC,
            stateValidator: _validateState,
            stateInputDecoration: InputDecoration(
              hintText: StringConstants.state,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.state,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
            city: cityTEC,
            cityValidator: _validateCity,
            cityInputDecoration: InputDecoration(
              hintText: StringConstants.city,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.city,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
            inputTextStyle: TextStyle(color: ColorConstants.black54),
            dialogBGColor: ColorConstants.white,
          ),
          const SizedBox(height: 60.0),
          Visibility(
            visible: true,
            replacement: Center(
              child: CircularProgressIndicator(
                color: ColorConstants.indigo,
                strokeWidth: 3.0,
              ),
            ),
            child: GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  FocusScope.of(context).unfocus();
                  selectedLocation.country.value = countryTEC.text;
                  selectedLocation.state.value = stateTEC.text;
                  selectedLocation.city.value = cityTEC.text;

                  locationService.getLocationFromAddress(
                      "${cityTEC.text}, ${stateTEC.text}, ${countryTEC.text}");

                  Navigator.pop(context);
                }
              },
              child: Text(
                StringConstants.save,
                style: TextStyle(
                  fontSize: 18,
                  color: ColorConstants.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
