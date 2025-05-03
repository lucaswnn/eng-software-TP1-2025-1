import 'dart:collection';
import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/tads/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class CalendarInterface extends StatefulWidget {
  const CalendarInterface({super.key});

  ListTile eventListTileBuilder(
    BuildContext context,
    int index,
    void Function(CalendarEvent event) onSelectedEvent,
    List<CalendarEvent> events,
  );

  List<Widget> actionsBuilder(
    BuildContext context,
    DateTime date,
    void Function(LinkedHashMap<DateTime, List<CalendarEvent>>) stateSetter,
  );

  @override
  State<StatefulWidget> createState() => _CalendarInterfaceState();
}

class _CalendarInterfaceState extends State<CalendarInterface> {
  late final ValueNotifier<List<CalendarEvent>> _selectedEvents;
  late final ValueNotifier<CalendarEvent> _selectedEvent;

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
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
    _selectedEvents = ValueNotifier([]);
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
    final days = _daysInRange(start, end);

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

  void _setEvents(LinkedHashMap<DateTime, List<CalendarEvent>> events) {
    setState(() => _events = events);
    _rangeSelectionMode == RangeSelectionMode.toggledOff
        ? _selectedEvents.value = _getEventsForDay(_selectedDay!)
        : _selectedEvents.value = _getEventsForRange(_rangeStart!, _rangeEnd!);
  }

  @override
  Widget build(BuildContext context) {
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
                          return widget.eventListTileBuilder(
                            context,
                            index,
                            _onEventSelected,
                            value,
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
                _selectedDay != null
                    ? ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        children: widget.actionsBuilder(
                            context, _selectedDay!, _setEvents),
                      )
                    : const SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }
}

List<DateTime> _daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}