import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  Avatar({@required this.photoUrl});
  final String? photoUrl;

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<double>(begin: 12, end: 18).animate(_controller);
    _controller..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage:
          widget.photoUrl != null && widget.photoUrl != '' ? NetworkImage(widget.photoUrl ?? '') : null,
      child: widget.photoUrl == null || widget.photoUrl == ''
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: animation.value,
                  height: animation.value,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), color: AppColors.white),
                );
              },
            )
          : null,
    );
  }
}
