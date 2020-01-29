class Binding {
  String manufacturer, model, type, imageUrl, warning;

  String name() {
    return model + (type == null ? '' : ' (' + type + ')');
  }

  Binding.fromJson(Map<String, dynamic> bindingJson) {
    manufacturer = bindingJson['manufacturer'];
    type = bindingJson.containsKey('type') ? bindingJson['type'] : null;
    model = bindingJson['model'];
    warning =
        bindingJson.containsKey('warning') ? bindingJson['warning'] : null;
  }
}
