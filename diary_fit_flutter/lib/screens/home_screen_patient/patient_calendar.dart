import 'dart:collection';
import 'package:diary_fit/screens/calendar_interface.dart';
import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/tads/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientCalendar extends CalendarInterface {
  const PatientCalendar({super.key});

  @override
  List<Widget> actionsBuilder(
    BuildContext context,
    DateTime date,
    void Function(LinkedHashMap<DateTime, List<CalendarEvent>>) stateSetter,
  ) {
    final dataState = context.watch<DataProvider>();
    final authState = context.read<AuthProvider>();
    final auth = authState.clientAuth;

    Future<void> sendWeight(String weight) async {
      dataState.sendWeight(auth!, double.parse(weight), date);
    }

    return [
      _ListTileAdder(
          inputLabel: 'Adicionar peso',
          validator: (value) {
            if (value == null) {
              return 'Insira um valor';
            }
            if (double.tryParse(value) == null) {
              return 'Insira um valor válido';
            }
            return null;
          },
          future: sendWeight)
    ];
  }

  @override
  ListTile eventListTileBuilder(
    BuildContext context,
    int index,
    void Function(CalendarEvent event) onEventSelected,
    List<CalendarEvent> events,
  ) {
    return ListTile(
      onTap: () => onEventSelected,
      title: Text('${events[index]}'),
    );
  }
}

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
/*
class PatientCalendar extends StatefulWidget {
  const PatientCalendar({super.key});

  @override
  State<PatientCalendar> createState() => _PatientCalendarState();
}

class _PatientCalendarState extends State<PatientCalendar> {
  late final ValueNotifier<List<CalendarEvent>> _selectedEvents;
  late final ValueNotifier<CalendarEvent> _selectedEvent;

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final DateTime _firstDay = DateTime(2024);
  final DateTime _lastDay = DateTime(2035, 12, 31);

  LinkedHashMap<DateTime, List<CalendarEvent>>? _events;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _selectedEvent = ValueNotifier(const CalendarNullEvent());

    _events = context.read<DataProvider>().calendarData;
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _selectedEvent.dispose();
    super.dispose();
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events?[day] ?? [];
  }

  List<CalendarEvent> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(
    DateTime selectedDay,
    DateTime focusedDay,
  ) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }

    _selectedEvent.value = const CalendarNullEvent();
  }

  void _onRangeSelected(
    DateTime? start,
    DateTime? end,
    DateTime focusedDay,
  ) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }

    _selectedEvent.value = const CalendarNullEvent();
  }

  void _onEventSelected(CalendarEvent event) {
    _selectedEvent.value = event;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>().clientAuth;
    final dataState = context.watch<DataProvider>();
    final events = dataState.calendarData;

    return Flexible(
      child: Row(
        children: [
          Flexible(
            child: Column(
              children: [
                TableCalendar<CalendarEvent>(
                  locale: Intl.defaultLocale,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month'
                  },
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<CalendarEvent>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () => _onEventSelected(value[index]),
                            title: Text('${value[index]}'),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 100, maxWidth: 200, maxHeight: 500),
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: _selectedEvent,
                  builder: (context, event, _) => event.buildContent(context),
                ),
                const SizedBox(height: 30),
                ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Adicionar peso'),
                      onTap: () async {
                        await dataState.sendWeight(auth!, 10, DateTime.now());

                        setState(() => _events = events);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Adicionar refeição feita'),
                      onTap: () async {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Adicionar exercício feito'),
                      onTap: () async {},
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
*/
