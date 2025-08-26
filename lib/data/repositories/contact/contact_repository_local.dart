import 'package:ayron_crm/config/assets.dart';
import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/repositories/data_repository_local.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';

class ContactRepositoryLocal extends DataRepositoryLocal<Contact>
    implements ContactRepository {
  ContactRepositoryLocal({required super.localDataService});

  @override
  String get assetFile => Assets.contacts;

  @override
  bool filter(Contact entity, Map<String, dynamic>? search) {
    if (search == null) return true;
    if (search["filter"] != null) {
      return entity.name.toLowerCase().contains(search["filter"]) ||
          entity.tel.toLowerCase().contains(search["filter"].toLowerCase()) ||
          entity.instagram.toLowerCase().contains(
            search["filter"].toLowerCase(),
          ) ||
          entity.email.toLowerCase().contains(search["filter"].toLowerCase());
    }
    return (search["name"] == null
            ? true
            : entity.name.toLowerCase().contains(
                search["name"].toLowerCase(),
              )) &&
        (search["state"] == null ? true : entity.state == search["state"]);
  }

  @override
  Contact Function(Map<String, dynamic> json) get fromJson => Contact.fromJson;

  @override
  Contact newEntity(int id) => Contact.create(id);

  @override
  String get typeName => "Contact";
}
