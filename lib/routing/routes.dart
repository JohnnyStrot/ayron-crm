abstract final class Routes {
  static const home = '/';
  static const login = '/$loginRelative';
  static const overview = '/$overviewRelative';
  static const analysis = '/$analysisRelative';
  static const data = '/$dataRelative';
  static const locations = '$data/$locationsRelative';
  static const create = '/$createRelative';

  static const loginRelative = 'login';
  static const overviewRelative = 'overview';
  static const analysisRelative = 'analysis';
  static const dataRelative = 'data';
  static const locationsRelative = 'location';
  static const createRelative = 'create';
}
