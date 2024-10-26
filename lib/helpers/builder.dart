import 'package:flutter/material.dart';

//display error message to user
void showErrorMessage({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ),
  );
}

//popup success message to user
void showSuccessMessage({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 5),
      animation: const AlwaysStoppedAnimation(1),
    ),
  );
}

void showConfirmDialog({
  required int index,
  required BuildContext context,
  required String title,
  required String message,
  required Function onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            // primary: Colors.white,
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            onConfirm(index);
            Navigator.pop(context);
          },
          child: const Text("Đồng ý"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            // primary: Colors.white,
            backgroundColor: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Hủy"),
        ),
      ],
    ),
  );
}

void showMessageDialog({
  required BuildContext context,
  required String message,
  IconData icon = Icons.info,
  Color color = Colors.green,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      alignment: Alignment.center,
      content: Text(message),
      icon: Icon(icon, color: color),
      actions: [
        TextButton(
          style: TextButton.styleFrom(),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Đóng"),
        ),
      ],
    ),
  );
}
