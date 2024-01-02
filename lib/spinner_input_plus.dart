import 'package:flutter/material.dart';
import 'dart:async';

import 'package:intl/intl.dart' as intl;

/// Spinner Input Button Style
class SpinnerButtonStyle {
  /// Color of the spinner button
  Color? color;

  /// Text color of the spinner button
  Color? textColor;
  Widget? child;

  /// Width of the spinner button
  double? width;

  /// Height of the spinner button
  double? height;

  /// Border radius of the spinner button
  BorderRadius? borderRadius;

  /// Height elevation of the spinner button
  double? highlightElevation;

  /// Highlight color of the spinner button
  Color? highlightColor;

  /// Elevation of the spinner button
  double? elevation;

  SpinnerButtonStyle(
      {this.color,
      this.textColor,
      this.child,
      this.width,
      this.height,
      this.borderRadius,
      this.highlightElevation,
      this.highlightColor,
      this.elevation});
}

/// Spinner Input like HTML5 spinners
class SpinnerInput extends StatefulWidget {
  /// Disable the value edit popup
  final bool disabledPopup;

  /// The initial spinner value
  final double spinnerValue;

  /// Width of the text in the middle (displaying current value)
  final double? middleNumberWidth;

  /// Padding of the text in the middle (displaying current value)
  final EdgeInsets middleNumberPadding;

  /// Text style in the middle (displaying current value)
  final TextStyle middleNumberStyle;

  /// Background of the text in the middle (displaying current value)
  final Color? middleNumberBackground;

  /// The minimum allowed spinner value
  final double minValue;

  /// The maximum allowed spinner value
  final double maxValue;

  /// Step size of one spinner tick
  final double step;

  /// Number of fractional digits displayed
  final int fractionDigits;

  /// Speed of the long press (duration)
  final Duration longPressSpeed;

  /// OnChange handler callback
  final Function(double newValue)? onChange;

  /// Is long press disabled
  final bool disabledLongPress;

  /// Plus button's style
  final SpinnerButtonStyle? plusButton;

  /// Minus button's style
  final SpinnerButtonStyle? minusButton;

  /// Popup button's style
  final SpinnerButtonStyle? popupButton;

  /// Number format of the spinner value
  final intl.NumberFormat? numberFormat;

  /// Text style of the value edit popup
  final TextStyle popupTextStyle;

  /// Text direction of the value edit popup
  final TextDirection direction;

  const SpinnerInput({
    Key? key,
    required this.spinnerValue,
    this.middleNumberWidth,
    this.middleNumberBackground,
    this.middleNumberPadding = const EdgeInsets.all(5),
    this.middleNumberStyle = const TextStyle(fontSize: 20),
    this.maxValue = 100,
    this.minValue = 0,
    this.step = 1,
    this.fractionDigits = 0,
    this.longPressSpeed = const Duration(milliseconds: 50),
    this.disabledLongPress = false,
    this.disabledPopup = false,
    this.onChange,
    this.plusButton,
    this.minusButton,
    this.popupButton,
    this.numberFormat,
    this.direction = TextDirection.ltr,
    this.popupTextStyle =
        const TextStyle(fontSize: 18, color: Colors.black87, height: 1.15),
  }) : super(key: key);

  @override
  SpinnerInputState createState() => SpinnerInputState();
}

class SpinnerInputState extends State<SpinnerInput>
    with TickerProviderStateMixin {
  TextEditingController? textEditingController;
  AnimationController? popupAnimationController;
  final _focusNode = FocusNode();

  Timer? timer;

  SpinnerButtonStyle _plusSpinnerStyle = SpinnerButtonStyle();
  SpinnerButtonStyle _minusSpinnerStyle = SpinnerButtonStyle();
  SpinnerButtonStyle _popupButtonStyle = SpinnerButtonStyle();

  @override
  void initState() {
    /// popup text field
    textEditingController =
        TextEditingController(text: _formatted(widget.spinnerValue));

    /// popup animation controller
    popupAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        textEditingController?.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textEditingController?.value.text.length ?? 0,
        );
      }
    });

    // initialize buttons
    _plusSpinnerStyle = widget.plusButton ?? SpinnerButtonStyle();
    _plusSpinnerStyle.child ??= const Icon(Icons.add);
    _plusSpinnerStyle.color ??= const Color(0xff9EA8F0);
    _plusSpinnerStyle.textColor ??= Colors.white;
    _plusSpinnerStyle.borderRadius ??= BorderRadius.circular(50);
    _plusSpinnerStyle.width ??= 35;
    _plusSpinnerStyle.height ??= 35;
    _plusSpinnerStyle.elevation ??= null;
    _plusSpinnerStyle.highlightColor ??= null;
    _plusSpinnerStyle.highlightElevation ??= null;

    _minusSpinnerStyle = widget.minusButton ?? SpinnerButtonStyle();
    _minusSpinnerStyle.child ??= const Icon(Icons.remove);
    _minusSpinnerStyle.color ??= const Color(0xff9EA8F0);
    _minusSpinnerStyle.textColor ??= Colors.white;
    _minusSpinnerStyle.borderRadius ??= BorderRadius.circular(50);
    _minusSpinnerStyle.width ??= 35;
    _minusSpinnerStyle.height ??= 35;
    _minusSpinnerStyle.elevation ??= null;
    _minusSpinnerStyle.highlightColor ??= null;
    _minusSpinnerStyle.highlightElevation ??= null;

    _popupButtonStyle = widget.popupButton ?? SpinnerButtonStyle();
    _popupButtonStyle.child ??= const Icon(Icons.check);
    _popupButtonStyle.color ??= Colors.lightGreen;
    _popupButtonStyle.textColor ??= Colors.white;
    _popupButtonStyle.borderRadius ??= BorderRadius.circular(5);
    _popupButtonStyle.width ??= 35;
    _popupButtonStyle.height ??= 35;
    _popupButtonStyle.elevation ??= null;
    _popupButtonStyle.highlightColor ??= null;
    _popupButtonStyle.highlightElevation ??= null;

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.direction,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: _minusSpinnerStyle.width,
                height: _minusSpinnerStyle.height,
                child: GestureDetector(
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    color: _minusSpinnerStyle.color,
                    textColor: _minusSpinnerStyle.textColor,
                    elevation: _minusSpinnerStyle.elevation,
                    highlightColor: _minusSpinnerStyle.highlightColor,
                    highlightElevation: _minusSpinnerStyle.highlightElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: _minusSpinnerStyle.borderRadius!,
                    ),
                    onPressed: () {
                      decrease();
                    },
                    child: _minusSpinnerStyle.child,
                  ),
                  onLongPress: () {
                    if (widget.disabledLongPress == false) {
                      timer = Timer.periodic(widget.longPressSpeed, (timer) {
                        decrease();
                      });
                    }
                  },
                  onLongPressUp: () {
                    timer?.cancel();
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (widget.disabledPopup == false &&
                      popupAnimationController != null) {
                    if (popupAnimationController!.isDismissed) {
                      popupAnimationController!.forward();
                      _focusNode.requestFocus();
                    } else {
                      popupAnimationController!.reverse();
                    }
                  }
                },
                child: Container(
                  width: widget.middleNumberWidth,
                  padding: widget.middleNumberPadding,
                  color: widget.middleNumberBackground,
                  child: Text(
                    _formatted(widget.spinnerValue),
                    textAlign: TextAlign.center,
                    style: widget.middleNumberStyle,
                  ),
                ),
              ),
              SizedBox(
                width: _plusSpinnerStyle.width,
                height: _plusSpinnerStyle.height,
                child: GestureDetector(
                  child: MaterialButton(
                    elevation: _plusSpinnerStyle.elevation,
                    highlightColor: _plusSpinnerStyle.highlightColor,
                    highlightElevation: _plusSpinnerStyle.highlightElevation,
                    padding: const EdgeInsets.all(0),
                    color: _plusSpinnerStyle.color,
                    textColor: _plusSpinnerStyle.textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: _plusSpinnerStyle.borderRadius!,
                    ),
                    onPressed: () {
                      increase();
                    },
                    child: _plusSpinnerStyle.child,
                  ),
                  onLongPress: () {
                    if (widget.disabledLongPress == false) {
                      timer = Timer.periodic(widget.longPressSpeed, (timer) {
                        increase();
                      });
                    }
                  },
                  onLongPressUp: () {
                    timer?.cancel();
                  },
                ),
              ),
            ],
          ),
          if (widget.disabledPopup == false)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: textFieldPopUp(),
            ),
        ],
      ),
    );
  }

  void increase() {
    double value = widget.spinnerValue;
    value += widget.step;
    if (value <= widget.maxValue) {
      textEditingController?.text = _formatted(value);
      setState(() {
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      });
    }
  }

  void decrease() {
    double value = widget.spinnerValue;
    value -= widget.step;
    if (value >= widget.minValue) {
      textEditingController?.text = _formatted(value);
      setState(() {
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      });
    }
  }

  Widget textFieldPopUp() {
    int maxLength =
        widget.maxValue.toStringAsFixed(widget.fractionDigits).length;
    if (widget.fractionDigits > 0) maxLength += widget.fractionDigits;

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: popupAnimationController!,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: TextField(
                  // inputFormatters: [
                  //   TextInputFormatter.withFunction((oldValue, newValue) {
                  //     if (widget.numberFormat != null) {
                  //       return TextEditingValue(text: );
                  //     }
                  //     return newValue;
                  //   })
                  // ],
                  maxLength: maxLength,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: widget.popupTextStyle,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                  ),
                  controller: textEditingController,
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: _popupButtonStyle.width,
                  height: _popupButtonStyle.height,
                  child: MaterialButton(
                    padding: const EdgeInsets.all(1),
                    color: _popupButtonStyle.color,
                    textColor: _popupButtonStyle.textColor,
                    elevation: _popupButtonStyle.elevation,
                    highlightColor: _popupButtonStyle.highlightColor,
                    highlightElevation: _popupButtonStyle.highlightElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: _popupButtonStyle.borderRadius!,
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      try {
                        double value = widget.numberFormat != null
                            ? widget.numberFormat!
                                .parse(textEditingController?.text ?? "0")
                                .toDouble()
                            : double.parse(textEditingController?.text ?? "0");
                        if (value <= widget.maxValue &&
                            value >= widget.minValue) {
                          setState(() {
                            if (widget.onChange != null) {
                              widget.onChange!(value);
                            }
                          });
                        } else {
                          textEditingController?.text =
                              _formatted(widget.spinnerValue);
                        }
                      } catch (e) {
                        textEditingController?.text =
                            _formatted(widget.spinnerValue);
                      }
                      popupAnimationController?.reset();
                    },
                    child: _popupButtonStyle.child,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatted(double value) {
    return widget.numberFormat != null
        ? widget.numberFormat!.format(value)
        : value.toStringAsFixed(widget.fractionDigits);
  }
}
