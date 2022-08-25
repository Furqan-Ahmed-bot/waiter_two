import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class AnimatedSwipeButton extends StatefulWidget {
  const AnimatedSwipeButton({
    Key? key,
    required this.buttonText,
    this.height = 60,
    this.borderWidth = 3,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  final double? height;
  final String buttonText;
  final double? borderWidth;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  _AnimatedSwipeButtonState createState() => _AnimatedSwipeButtonState();
}

class _AnimatedSwipeButtonState extends State<AnimatedSwipeButton> {
  late double _maxWidth;
  late double _handleSize;
  double _dragValue = 0;
  double _dragWidth = 0;
  bool _confirmed = false;
  @override
  Widget build(BuildContext context) {
    _handleSize = (widget.height! - (widget.borderWidth! * 2));
    return LayoutBuilder(builder: (context, constraint) {
      _maxWidth = constraint.maxWidth;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: widget.height,
        decoration: BoxDecoration(
          color: _confirmed ? AppConst.appColorWhite : context.read<ThemeProvider>().selectedPrimaryColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: _confirmed ? AppConst.appColorWhite : context.read<ThemeProvider>().selectedPrimaryColor,
            width: widget.borderWidth!,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Center(
                child: Text(
                  _confirmed ? '${widget.buttonText} successful' : 'Swipe To ${widget.buttonText}',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: _confirmed ? Colors.black54 : Colors.white,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: _dragWidth <= _handleSize ? _handleSize : _dragWidth,
                child: Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    !_confirmed ? GestureDetector(
                      onVerticalDragUpdate: _onDragUpdate,
                      onVerticalDragEnd: _onDragEnd,
                      child: Container(
                        width: _handleSize,
                        height: _handleSize,
                        decoration: BoxDecoration(
                          color: AppConst.appColorWhite,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: context.read<ThemeProvider>().selectedPrimaryColor,
                          size: 40,
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragValue = (details.globalPosition.dx) / _maxWidth;
      _dragWidth = _maxWidth * _dragValue;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragValue > .9) {
      _dragValue = 1;
    } else {
      _dragValue = 0;
    }

    setState(() {
      _dragWidth = _maxWidth * _dragValue;
      _confirmed = _dragValue == 1;
    });

    if (_dragValue == 1) {
      widget.onConfirm();
    } else {
      widget.onCancel();
    }
  }
}