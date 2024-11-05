import 'package:quiz/widgets/cores.dart';
import 'package:flutter/material.dart';

InputDecoration inputDec(String label, IconData? icone) {
  return InputDecoration(
    prefixIcon: Icon(icone, color: Colors.grey.shade400),
    labelText: label,
    labelStyle: TextStyle(color: Colors.grey.shade400),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.grey.shade400, // Cor da borda
        width: 2.0, // Espessura da borda
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.grey.shade400, // Cor da borda
        width: 2.0, // Espessura da borda
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: corDestaque(), // Cor da borda quando o campo está focado
        width: 3.0, // Espessura da borda quando o campo está focado
      ),
    ),
  );
}