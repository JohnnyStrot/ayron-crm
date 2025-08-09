import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/list_widgets/opportunity_list_entry.dart';

class ContactListEntry extends OpportunityListEntry<Contact> {
  const ContactListEntry({
    super.key,
    required Contact contact,
    required super.onDelete,
  }) : super(opportunity: contact);

  @override
  String get route => Routes.contacts;
}
