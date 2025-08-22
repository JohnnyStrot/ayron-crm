import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';
import 'package:ayron_crm/ui/details/details_viewmodel.dart';

class ContactDetailsViewmodel
    extends DetailsViewmodel<Contact, ContactDetailsViewmodel> {
  ContactDetailsViewmodel({required ContactRepository contactRepository})
    : super(repository: contactRepository);

  @override
  String get typeName => "Kontakt";
}
