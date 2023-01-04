import 'package:flutter/material.dart';

class FiltroBusquedaWidget extends StatefulWidget {
  const FiltroBusquedaWidget({Key? key}) : super(key: key);

  @override
  State<FiltroBusquedaWidget> createState() => _FiltroBusquedaWidgetState();
}

String _groupValue = 'nada';

class _FiltroBusquedaWidgetState extends State<FiltroBusquedaWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Filtros'),
        ),
        body: Column(
          children: <Widget>[
            _myRadioButton(
              title: "Albañilería / Construcción",
              value: 'Construccion',
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Trabajos Domésticos",
              value: 'Trabajos Domesticos',
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Carpintería",
              value: "Carpinteria",
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Plomería",
              value: "Plomeria",
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Electricidad",
              value: "Electricidad",
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Atención al cliente",
              value: "Atencion al cliente",
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Vendedor/a",
              value: "Vendedor",
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Servicios Informáticos",
              value: "Servicios Informaticos",
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Servicios Profesionales",
              value: "Servicios Profesionales",
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Otros",
              value: "Otros",
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromRGBO(29, 53, 87, 1.0),
                ),
              ),
              onPressed: () {
                if (!_groupValue.contains('nada')) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'homefiltros',
                      arguments: {_groupValue});
                  _groupValue = 'nada';
                } else {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'home');
                }
              },
              child: const Text(
                'Filtrar',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ));
  }

  Widget _myRadioButton({title, value, onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }
}
