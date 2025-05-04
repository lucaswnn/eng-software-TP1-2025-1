import 'package:diary_fit/screens/calendar_interface.dart';
import 'package:diary_fit/tads/calendar_event.dart';
import 'package:flutter/material.dart';

// Class responsible for nutritionist UI calendar
// It implements the required CalendarInterface methods
// The abstract class CalendarInterface is the main calendar builder

class NutritionistCalendar extends CalendarInterface {
  const NutritionistCalendar({super.key});

  // This method is responsible for adding action buttons at the right side of the
  // calendar UI
  @override
  List<Widget> actionsBuilder(
    BuildContext context,
    DateTime date,
    void Function() stateSetter,
  ) {
    return [];
  }

  // This method is responsible for building the ListTile components under the
  // calendar UI

  // TODO: criar um layout diferente para os ListTiles
  // Recomendo colocar ícones dependendo do CalendarEventType
  // Exemplo: switch(event.type){case CalendarEventType.weightRegister: icon = ...}
  @override
  ListTile eventListTileBuilder(
    BuildContext context,
    int index,
    void Function(CalendarEvent event) onEventSelected,
    List<CalendarEvent> events,
  ) {
    return ListTile(
      onTap: () => onEventSelected(events[index]),
      title: Text('${events[index]}'),
    );
  }
}

// Private class responsible for wrapping the input UI
// Easier for building action ListTiles
class _ListTileAdder extends StatefulWidget {
  final String inputLabel;
  final String? Function(String? value) validator;
  final Future<void> Function(String) future;

  const _ListTileAdder({
    required this.inputLabel,
    required this.validator,
    required this.future,
  });

  @override
  State<_ListTileAdder> createState() => _ListTileAdderState();
}

class _ListTileAdderState extends State<_ListTileAdder> {
  final _key = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(
                widget.inputLabel,
                style: const TextStyle(fontSize: 15),
              ),
              onTap: () async {
                if (_key.currentState!.validate()) {
                  // Do the future job (e.g. sendWeight)
                  // and then clear the TextField
                  await widget.future(_controller.text);
                  _controller.clear();
                }
              },
            ),
            TextFormField(
              controller: _controller,
              validator: widget.validator,
            ),
          ],
        ),
      ),
    );
  }
}
