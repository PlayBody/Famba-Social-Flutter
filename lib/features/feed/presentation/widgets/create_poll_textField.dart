import '../../../../core/theme/colors.dart';
import '../../../../extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePollTextField extends StatefulWidget {
  const CreatePollTextField({
    Key key,
    @required this.onSubmitted,
    @required this.hintText,
    @required this.controller,
  }) : super(key: key);
  final StringToVoidFunc onSubmitted;
  final String hintText;
  final TextEditingController controller;
  @override
  _CreatePollTextFieldState createState() => _CreatePollTextFieldState();
}

class _CreatePollTextFieldState extends State<CreatePollTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
        child: TextField(
          maxLines: 1,
          controller: widget.controller,
          inputFormatters: [LengthLimitingTextInputFormatter(25)],
          style: TextStyle(
            color: const Color(0xFF6A6D70),
            fontFamily: 'CeraPro',
            fontWeight: FontWeight.w300,
            fontSize: 15,
          ),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            isDense: true,
            suffix: Text((25 -
                    (widget.controller.text == null
                        ? 0
                        : widget.controller.text.length))
                .toString()),
            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.colorPrimary),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: widget.onSubmitted,
        ),
      ),
    );
  }
}
