import 'package:flutter/material.dart';

class TotalWidget extends StatelessWidget {
  final String title;

  const TotalWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: const Color(0xFF6B6B6B),
                    ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.black,
                    size: 15.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.001,
                  ),
                  Text(
                    '+24%',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: const Color(0xFF6B6B6B),
                    ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.001,
              ),
              const Text(
                '42,069.00',
                style: TextStyle(
                  fontSize: 26.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
