import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';
import 'package:ayron_crm/data/repositories/data_repository_remote.dart';

class ContactRepositoryRemote extends DataRepositoryRemote<Contact>
    implements ContactRepository {
  ContactRepositoryRemote({required super.apiService});

  @override
  Contact Function(Map<String, dynamic> json) get fromJson => Contact.fromJson;

  @override
  String get typeName => "Kontakt";

  @override
  String get typeApiEndpoint => "contact";
}
