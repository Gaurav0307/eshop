import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../models/country_state_city_picker_models/city_model.dart';
import '../../models/country_state_city_picker_models/country_model.dart';
import '../../models/country_state_city_picker_models/state_model.dart';

class CountryStateCityPicker extends StatefulWidget {
  final double spacing;
  final TextEditingController country;
  final void Function(String)? onCountryChange;
  final String? Function(String?)? countryValidator;
  final InputDecoration? countryInputDecoration;
  final TextEditingController state;
  final void Function(String)? onStateChange;
  final String? Function(String?)? stateValidator;
  final InputDecoration? stateInputDecoration;
  final TextEditingController city;
  final void Function(String)? onCityChange;
  final String? Function(String?)? cityValidator;
  final InputDecoration? cityInputDecoration;
  final TextStyle inputTextStyle;
  final Color? dialogBGColor;
  final Color? snackBarBGColor;

  const CountryStateCityPicker({
    super.key,
    this.spacing = 16.0,
    required this.country,
    this.onCountryChange,
    this.countryValidator,
    this.countryInputDecoration,
    required this.state,
    this.onStateChange,
    this.stateValidator,
    this.stateInputDecoration,
    required this.city,
    this.onCityChange,
    this.cityValidator,
    this.cityInputDecoration,
    required this.inputTextStyle,
    this.dialogBGColor,
    this.snackBarBGColor,
  });

  @override
  State<CountryStateCityPicker> createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  List<CountryModel> _countryList = [];
  final List<StateModel> _stateList = [];
  final List<CityModel> _cityList = [];

  List<CountryModel> _countrySubList = [];
  List<StateModel> _stateSubList = [];
  List<CityModel> _citySubList = [];
  String _title = '';

  @override
  void initState() {
    _getCountry();
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    if (widget.country.text.isNotEmpty) {
      await _getState(await _getCountryId(widget.country.text));
    }

    if (widget.state.text.isNotEmpty) {
      await _getCity(await _getStateId(widget.state.text));
    }
  }

  Future<void> _getCountry() async {
    _countryList.clear();
    var jsonString = await rootBundle.loadString('assets/json/country.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _countryList =
          body.map((dynamic item) => CountryModel.fromJson(item)).toList();
      _countrySubList = _countryList;
    });
  }

  Future<void> _getState(String countryId) async {
    _stateList.clear();
    _cityList.clear();
    List<StateModel> subStateList = [];
    var jsonString = await rootBundle.loadString('assets/json/state.json');
    List<dynamic> body = json.decode(jsonString);

    subStateList =
        body.map((dynamic item) => StateModel.fromJson(item)).toList();
    for (var element in subStateList) {
      if (element.countryId == countryId) {
        setState(() {
          _stateList.add(element);
        });
      }
    }
    _stateSubList = _stateList;
  }

  Future<void> _getCity(String stateId) async {
    _cityList.clear();
    List<CityModel> subCityList = [];
    var jsonString = await rootBundle.loadString('assets/json/city.json');
    List<dynamic> body = json.decode(jsonString);

    subCityList = body.map((dynamic item) => CityModel.fromJson(item)).toList();
    for (var element in subCityList) {
      if (element.stateId == stateId) {
        setState(() {
          _cityList.add(element);
        });
      }
    }
    _citySubList = _cityList;
  }

  Future<String> _getCountryId(String countryName) async {
    String countryId = '';
    var jsonString = await rootBundle.loadString('assets/json/country.json');
    List<dynamic> body = json.decode(jsonString);

    List<CountryModel> countries =
        body.map((dynamic item) => CountryModel.fromJson(item)).toList();

    for (var country in countries) {
      if (country.name == countryName) {
        countryId = country.id;
      }
    }

    return countryId;
  }

  Future<String> _getStateId(String stateName) async {
    String stateId = '';

    var jsonString = await rootBundle.loadString('assets/json/state.json');
    List<dynamic> body = json.decode(jsonString);

    List<StateModel> states =
        body.map((dynamic item) => StateModel.fromJson(item)).toList();

    for (var state in states) {
      if (state.name == stateName) {
        stateId = state.id;
      }
    }

    return stateId;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Country TextField
        TextFormField(
          controller: widget.country,
          validator: widget.countryValidator,
          onTap: () {
            setState(() => _title = 'Country');
            _showDialog(context);
          },
          decoration: widget.countryInputDecoration ??
              defaultDecoration.copyWith(hintText: 'Select country'),
          readOnly: true,
          onChanged: widget.onCountryChange,
        ),
        SizedBox(height: widget.spacing),

        ///State TextField
        TextFormField(
          controller: widget.state,
          validator: widget.stateValidator,
          onTap: () {
            setState(() => _title = 'State');
            if (widget.country.text.isNotEmpty) {
              _showDialog(context);
            } else {
              _showSnackBar('Select Country');
            }
          },
          decoration: widget.stateInputDecoration ??
              defaultDecoration.copyWith(hintText: 'Select state'),
          readOnly: true,
          onChanged: widget.onStateChange,
        ),
        SizedBox(height: widget.spacing),

        ///City TextField
        TextFormField(
          controller: widget.city,
          validator: widget.cityValidator,
          onTap: () {
            setState(() => _title = 'City');
            if (widget.state.text.isNotEmpty) {
              _showDialog(context);
            } else {
              _showSnackBar('Select State');
            }
          },
          decoration: widget.cityInputDecoration ??
              defaultDecoration.copyWith(hintText: 'Select city'),
          readOnly: true,
          onChanged: widget.onCityChange,
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();

    showGeneralDialog(
      barrierLabel: _title,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 350),
      context: context,
      pageBuilder: (context, __, ___) {
        return Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: widget.dialogBGColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        _title,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ///Text Field
                      TextField(
                        controller: _title == 'Country'
                            ? controller
                            : _title == 'State'
                                ? controller2
                                : controller3,
                        onChanged: (val) {
                          setState(() {
                            if (_title == 'Country') {
                              _countrySubList = _countryList
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(controller.text.toLowerCase()))
                                  .toList();
                            } else if (_title == 'State') {
                              _stateSubList = _stateList
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(controller2.text.toLowerCase()))
                                  .toList();
                            } else if (_title == 'City') {
                              _citySubList = _cityList
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(controller3.text.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 16.0),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          hintText: "Search here...",
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          isDense: true,
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),

                      ///Dropdown Items
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          itemCount: _title == 'Country'
                              ? _countrySubList.length
                              : _title == 'State'
                                  ? _stateSubList.length
                                  : _citySubList.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  if (_title == "Country") {
                                    widget.country.text =
                                        _countrySubList[index].name;
                                    _getState(_countrySubList[index].id);
                                    _countrySubList = _countryList;
                                    widget.state.clear();
                                    widget.city.clear();
                                  } else if (_title == 'State') {
                                    widget.state.text =
                                        _stateSubList[index].name;
                                    _getCity(_stateSubList[index].id);
                                    _stateSubList = _stateList;
                                    widget.city.clear();
                                  } else if (_title == 'City') {
                                    widget.city.text = _citySubList[index].name;
                                    _citySubList = _cityList;
                                  }
                                });
                                controller.clear();
                                controller2.clear();
                                controller3.clear();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, left: 10.0, right: 10.0),
                                child: Text(
                                  _title == 'Country'
                                      ? _countrySubList[index].name
                                      : _title == 'State'
                                          ? _stateSubList[index].name
                                          : _citySubList[index].name,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () {
                          if (_title == 'City' && _citySubList.isEmpty) {
                            widget.city.text = controller3.text;
                          }
                          _countrySubList = _countryList;
                          _stateSubList = _stateList;
                          _citySubList = _cityList;

                          controller.clear();
                          controller2.clear();
                          controller3.clear();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, -1),
            end: const Offset(0, 0),
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: widget.snackBarBGColor,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  InputDecoration defaultDecoration = const InputDecoration(
    isDense: true,
    hintText: 'Select',
    suffixIcon: Icon(Icons.arrow_drop_down),
    border: OutlineInputBorder(),
  );
}
