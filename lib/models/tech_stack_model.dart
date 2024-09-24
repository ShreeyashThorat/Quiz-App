class TechStackModel {
  String? id;
  String? icon;
  String? category;

  TechStackModel({this.id, this.icon, this.category});

  TechStackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['category'] = category;
    return data;
  }
}
