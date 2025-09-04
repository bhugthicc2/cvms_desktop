class VehicleEntry {
  final String name;
  final String vehicle;
  final String plateNumber;
  final Duration duration;

  VehicleEntry({
    required this.name,
    required this.vehicle,
    required this.plateNumber,
    required this.duration,
  });

  ///NEWWWWWWW

  String get formattedDuration {
    return "${duration.inHours}h ${duration.inMinutes % 60}m";
    //TODO: auto calcualtion of time in and current time =  duration
  }

  int get durationInMinutes => duration.inMinutes;
}
