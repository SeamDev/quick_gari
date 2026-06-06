import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputWidget extends StatefulWidget {
  final int length;

  /// Called whenever value changes
  final Function(String value)? onChanged;

  /// Called when OTP completed
  final Function(String value)? onCompleted;

  /// Called when submit button pressed
  final Function(String value)? onSubmit;

  /// Validation
  final String? Function(String value)? validator;

  const OtpInputWidget({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.onSubmit,
    this.validator,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  String? errorText;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(widget.length, (_) => TextEditingController());

    focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }

    for (final f in focusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  String get otpValue => controllers.map((e) => e.text).join();

  void validateAndSubmit() {
    String value = otpValue;

    if (widget.validator != null) {
      setState(() {
        errorText = widget.validator!(value);
      });

      if (errorText != null) return;
    }

    widget.onSubmit?.call(value);
  }

  void handleChange() {
    String value = otpValue;

    widget.onChanged?.call(value);

    if (widget.validator != null) {
      setState(() {
        errorText = widget.validator!(value);
      });
    }

    if (value.length == widget.length) {
      widget.onCompleted?.call(value);
    }
  }

  Widget buildField(int index) {
    return SizedBox(
      width: 55,
      height: 65,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(index == 0 ? widget.length : 1),
        ],
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: errorText != null ? Colors.red : Colors.green,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Handle paste
            if (value.length > 1) {
              final chars = value.split('');

              for (int i = 0; i < widget.length; i++) {
                controllers[i].text = i < chars.length ? chars[i] : '';
              }

              FocusScope.of(context).unfocus();

              handleChange();
              return;
            }
            // Normal typing
            if (index < widget.length - 1) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            }
          }

          handleChange();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: buildField(index),
            ),
          ),
        ),

        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: validateAndSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: const Text("Submit"),
          ),
        ),
      ],
    );
  }
}
