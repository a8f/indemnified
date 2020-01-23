class Binding {
  String manufacturer, model, type, imageUrl;

  String name() {
    return model + (type == null ? '' : type);
  }

  Binding.fromJson(Map<String, dynamic> bindingJson) {
    manufacturer = bindingJson['manufacturer'];
    type = bindingJson.containsKey('type') ? bindingJson['type'] : null;
    model = bindingJson['model'];
  }
}
