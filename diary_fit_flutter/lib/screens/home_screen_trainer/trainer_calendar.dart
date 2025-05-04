import 'package:diary_fit/screens/calendar_interface.dart';
import 'package:diary_fit/tads/calendar_event.dart';
import 'package:flutter/material.dart';

// Class responsible for trainer UI calendar
// It implements the required CalendarInterface methods
// The abstract class CalendarInterface is the main calendar builder

class TrainerCalendar extends CalendarInterface {
  const TrainerCalendar({super.key});

  // This method is responsible for adding action buttons at the right side of the
  // calendar UI
  @override
  List<Widget> actionsBuilder(
    BuildContext context,
    DateTime date,
    void Function() stateSetter,
  ) {
    return [
      ListTile(
        leading: const Icon(Icons.add),
        title: const Text('Add Workout Sheet'),
        subtitle: const Text('Create a workout Sheet for this date'),
        onTap: () {
          // Implement the action for adding a workout Sheet
          // Example: Navigate to a workout Sheet creation screen
          Navigator.pushNamed(context, '/addWorkoutSheet');
        },
      ),
    ];
  }

  // This method is responsible for building the ListTile components under the
  // calendar UI

  // TODO: criar um layout diferente para os ListTiles
  // Recomendo colocar ícones dependendo do CalendarEventType
  // Exemplo: switch(event.type){case CalendarEventType.workoutSheet: icon = ...}
  @override
  ListTile eventListTileBuilder(
    BuildContext context,
    int index,
    void Function(CalendarEvent event) onEventSelected,
    List<CalendarEvent> events,
  ) {
    final event = events[index];
    IconData icon;
    String subtitle;

    // Customize the icon and subtitle based on the event type
    switch (event.type) {
      case CalendarEventType.workoutSheet:
        icon = Icons.fitness_center;
        subtitle = 'Workout Sheet';
        break;
      case CalendarEventType.exerciseRegister:
        icon = Icons.directions_run;
        subtitle = 'Exercise Log';
        break;
      default:
        icon = Icons.event;
        subtitle = 'Event';
    }

    return ListTile(
      leading: Icon(icon),
      title: Text(event.toString()),
      subtitle: Text(subtitle),
      onTap: () => onEventSelected(event),
    );
  }
}