class HallData {
  String name;
  int capacity;
  int price;
  String image;
  bool active;

  HallData({
    required this.name,
    required this.capacity,
    required this.price,
    required this.image,
    this.active = true,
  });
}

List<HallData> hallList = [
  HallData(
    name: "Dream Forest Majestic Hall",
    capacity: 250,
    price: 2700,
    image: "assets/halls/dream_forest_majestic_hall.png",
  ),
  HallData(
    name: "Grand Ballroom",
    capacity: 300,
    price: 5000,
    image: "assets/halls/grand_ballroom.png",
  ),
  HallData(
    name: "Royal Garden Ballroom",
    capacity: 200,
    price: 3500,
    image: "assets/halls/royal_garden_ballroom.png",
  ),
];
