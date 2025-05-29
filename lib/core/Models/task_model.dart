class TaskModel {
  int id;
  String title;
  String? desc;
  bool isHighPriority;
  int isDone;
  TaskModel({
    required this.isDone,
    required this.id,
    required this.title,
    this.desc,
    required this.isHighPriority,
  });
  // Convert a TaskModel to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'isDone': isDone,
      'isHighPriority': isHighPriority ? 1 : 0, // Store bool as int
    };
  }

  // Create a TaskModel from Map<String, dynamic>
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      isDone: map['isDone'],
      isHighPriority: map['isHighPriority'] == 1, // Convert int back to bool
    );
  }
  @override
  String toString() {
    return 'id: $id , title: $title, isDone:$isDone , desc: $desc , high: $isHighPriority';
  }
}
