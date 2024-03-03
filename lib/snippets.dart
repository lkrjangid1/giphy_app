Future<String> fetchData() async {
  await Future.delayed(const Duration(seconds: 2));
  return "Data fetched successfully";
}

extension on List {
  customSort() {
    this.sort((a, b) => a.compareTo(b));
  }
}
