abstract final class Routes {
  static const home = '/';
  static const login = '/$loginRelative';
  static const overview = '/$overviewRelative';
  static const analysis = '/$analysisRelative';

  static const data = '/$dataRelative';
  static const locations = '$data/$locationsRelative';
  static const organisations = '$data/$organisationsRelative';
  static const create = '/$createRelative';
  static const gigs = '$data/$gigsRelative';
  static const events = '$data/$eventsRelative';
  static const contacts = '$data/$contactsRelative';
  static const songs = '$data/$songsRelative';
  static const bands = '$data/$bandsRelative';
  static const series = '$data/$seriesRelative';

  static const gigsRelative = 'gig';
  static const loginRelative = 'login';
  static const overviewRelative = 'overview';
  static const analysisRelative = 'analysis';
  static const dataRelative = 'data';
  static const locationsRelative = 'location';
  static const organisationsRelative = 'organisation';
  static const createRelative = 'create';
  static const eventsRelative = 'event';
  static const contactsRelative = 'contact';
  static const songsRelative = 'song';
  static const bandsRelative = 'band';
  static const seriesRelative = 'series';

  static const allOpportunitiesRelative = "opportunity/all";
  static const pastOpportunitiesRelative = "opportunity/past";
  static const activeOpportunitiesRelative = "opportunity/active";

  static const allOpportunities = "$analysis/$allOpportunitiesRelative";
  static const pastOpportunities = "$analysis/$pastOpportunitiesRelative";
  static const activeOpportunities = "$overview/$activeOpportunitiesRelative";

  static const dashboardRelative = "dashboard";
  static const dashboard = "$overview/$dashboardRelative";
}
