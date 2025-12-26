#
# Copyright 2017 Agilx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/usr/bin/env ruby
"""Exception Fingerprint tests"""
require 'test/unit/assertions'
include Test::Unit::Assertions


class PythonFingerprintTests

    def test_fp_tmp(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_python(
            ': upload-picked-order Internal Server Error for order 47353835 :invalid literal for int() with base 10: \'\' Traceback (most recent call last): '+
            '---   File "/srv/webapps/bigbasket.com/BigBasket/wapi/api.py", line 3648, in api_upload_process_picksubtypes '+
            '---     try: '+
            '---   File "/srv/webapps/bigbasket.com/BigBasket/product/models.py", line 227, in get_cached '+
            '---     \'product_description__category\').filter( '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/query.py", line 781, in filter '+
            '---     return self._filter_or_exclude(False, *args, **kwargs) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/query.py", line 799, in _filter_or_exclude '+
            '---     clone.query.add_q(Q(*args, **kwargs)) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/sql/query.py", line 1260, in add_q '+
            '---     clause, _ = self._add_q(q_object, self.used_aliases) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/sql/query.py", line 1286, in _add_q '+
            '---     allow_joins=allow_joins, split_subq=split_subq, '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/sql/query.py", line 1220, in build_filter '+
            '---     condition = self.build_lookup(lookups, col, value) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/sql/query.py", line 1114, in build_lookup '+
            '---     return final_lookup(lhs, rhs) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/lookups.py", line 24, in __init__ '+
            '---     self.rhs = self.get_prep_lookup() '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/lookups.py", line 74, in get_prep_lookup '+
            '---     return self.lhs.output_field.get_prep_value(self.rhs) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/fields/__init__.py", line 1849, in get_prep_value '+
            '---     return int(value) '+
            '--- ValueError: invalid literal for int() with base 10: \'\' ---'
        )
        assert_equal('ValueError', err_name)
        assert_equal('4ba02aa3b1e653a1bcf656be90183b6899561fad', fingerprint)
    end
    


    def test_fp_colon_in_code(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_python(
            ' Error while sending push notification for order: 46951142 Traceback (most recent call last): '+
            '---   File "order/models.py", line 10760, in alert_order_cancellation_via_email_and_push_notification '+
            '---     try: '+
            '---   File "order/models.py", line 22188, in creating_entry_in_van_asssign_history '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/query.py", line 555, in latest '+
            '---     return self._earliest_or_latest(field_name=field_name, direction="-") '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/query.py", line 549, in _earliest_or_latest '+
            '---     return obj.get() '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/query.py", line 379, in get '+
            '---     self.model._meta.object_name '+
            '--- DoesNotExist: TPLOrderStatusLog matching query does not exist. ---')
        assert_equal('DoesNotExist', err_name)
        assert_equal('3fd256270a264d132c848648789c9b2e7d49be9d', fingerprint)
    end

    def test_fp_colon_in_code1(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_python(
            '\'AnonymousUser\' object is not iterable Traceback (most recent call last): '+
            '---   File "/srv/webapps/bigbasket.com/BigBasket/mapi/cart_views.py", line 400, in get_cart_items_and_summary '+
            '---     sections_resp = self.add_section_to_basket(cart, cart_dict) '+
            '---   File "/srv/webapps/bigbasket.com/BigBasket/mapi/cart_views.py", line 425, in add_section_to_basket '+
            '---     particular_voucher_id=True) '+
            '---   File "/srv/webapps/bigbasket.com/BigBasket/evoucher/models.py", line 141, in get_promotional_evouchers '+
            '---     valid_vouchers = EVoucher.objects.get_valid_vouchers_for_cart(member, cart) '+
            '---   File "/srv/webapps/bigbasket.com/BigBasket/evoucher/models.py", line 302, in get_valid_vouchers_for_cart '+
            '---     voucher_order_association = self.get_voucher_order_association(vouchers, member) '+
            '---   File "/srv/webapps/bigbasket.com/BigBasket/evoucher/models.py", line 247, in get_voucher_order_association '+
            '---     order__isnull=False) \ '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/manager.py", line 85, in manager_method '+
            '---     return getattr(self.get_queryset(), name)(*args, **kwargs) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/query.py", line 781, in filter '+
            '---     return self._filter_or_exclude(False, *args, **kwargs) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/query.py", line 799, in _filter_or_exclude '+
            '---     clone.query.add_q(Q(*args, **kwargs)) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/sql/query.py", line 1260, in add_q '+
            '---     clause, _ = self._add_q(q_object, self.used_aliases) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/sql/query.py", line 1286, in _add_q '+
            '---     allow_joins=allow_joins, split_subq=split_subq, '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/sql/query.py", line 1189, in build_filter '+
            '---     self.check_related_objects(field, value, opts) '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/models/sql/query.py", line 1088, in check_related_objects '+
            '---     for v in value: '+
            '---   File "/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/utils/functional.py", line 239, in inner '+
            '---     return func(self._wrapped, *args) '+
            '--- TypeError: \'AnonymousUser\' object is not iterable --- ')
        assert_equal('TypeError', err_name)
        assert_equal('ca949fe44e2cd0c874b26d3153cc0f96389b0d6a', fingerprint)
    end

    def test_fp_one_err(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_python(
            ' Catching exception while processing the Message, '+
            'with Task ID = 41f916a3-a468-4d89-80c6-c6f1e9e7caef Traceback '+
            '(most recent call last): ---   File '+
            '"/srv/webapps/bigbasket.com/BigBasket/bbasync/consumer.py", '+
            'line 622, in retriable_dispatcher_task ---     '+
            'consumer_group, handler_call_args, handler_call_kwargs, '+
            'msg_headers) ---   File '+
            '"/srv/webapps/bigbasket.com/BigBasket/bbasync/consumer.py", '+
            'line 518, in dispatcher_task ---     '+
            'handler_call_kwargs) ---   '+
            'File "/srv/webapps/bigbasket.com/BigBasket/bbasync/consumer.py", '+
            'line 572, in _dispatcher_task ---     meth = fn(*args, **kwargs) '+
            '---   File "warehouse/services.py", line 1631, in '+
            'queueable_make_product_available ---     '+
            'make_product_available_sync(sr_obj_id, old_stock, force, stock) '+
            '---   File "warehouse/services.py", line 1638, in '+
            'make_product_available_sync ---     raise '+
            'Exception(\'Stock Reservation entry does not exist for %d\' '+
            '% sr_obj_id) --- Exception: Stock Reservation entry does '+
            'not exist for 1873208 --- ')
        assert_equal('Exception', err_name)
        assert_equal('50d4d0924c2bfc907f5dd976654a8c23d3449e79', fingerprint)
    end

    def test_fp_multi_err(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_python(
            'Traceback (most recent call last): ---   File '+
            '"/srv/webapps/bigbasket.com/BigBasket/member/models.py", line 9860, '+
            'in _bulk_update_locality ---     MemberAddressLocality.objects.'+
            'create(member_address_id=member_address_id, locality_id=locality.id) '+
            '--- AttributeError: \'NoneType\' object has no attribute \'id\' '+
            '---  Traceback (most recent call last): ---   File '+
            '"/srv/webapps/bigbasket.com/BigBasket/member/models.py", line 9860, '+
            'in _bulk_update_locality ---     MemberAddressLocality.objects.'+
            'create(member_address_id=member_address_id, locality_id=locality.id) '+
            '--- AttributeError: \'NoneType\' object has no attribute \'id\' --- ')
        assert_equal('AttributeError', err_name)
        assert_equal('a4602817afb0e58e9a3da77e4e512ac1b2b3fc42', fingerprint)
    end

    def test_fp_no_message(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_python(
            ': Locus: There are no orders which are open and mapped to send to '+
            'locus for Hub :Samalka , Slot Group : Delhi: D-S3 for order delivery '+
            'date 2018-04-29  Traceback (most recent call last): ---   File '+
            '"/srv/webapps/bigbasket.com/BigBasket/locus/management/commands/'+
            'locus_send_order_data.py", line 364, in send_batch ---     '+
            'order_ids=order_ids) ---   File "/srv/webapps/bigbasket.com/BigBasket/'+
            'locus/models.py", line 336, in create_batch_data ---     '+
            'raise NoOrdersForBatchException --- NoOrdersForBatchException ---  ')
        assert_equal('NoOrdersForBatchException', err_name)
        assert_equal('ad3a804eea4de5c0531b607a4f904ffd5a3ab9bb', fingerprint)
    end

    def test_fp_message_has_traceback(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_python(
            'SENDING MAIL: Unable to send using this \'MAILGUN\' mailer settings '+
            '{\'username\': \'postmaster@mg.bigbasket.com\', \'fail_silently\': '+
            'False, \'use_tls\': True, \'host\': \'smtp.mailgun.org\', '+
            '\'password\': \'8723123123\', \'port\': 587} Traceback '+
            '(most recent call last): ---   File "/srv/webapps/bigbasket.com/'+
            'BigBasket/saul/utils.py", line 568, in send ---     '+
            'connection.send_messages([message]) ---   File "/srv/webapps/'+
            'bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/'+
            'site-packages/django/core/mail/backends/smtp.py", line 111, '+
            'in send_messages ---     sent = self._send(message) ---   File '+
            '"/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/'+
            'python2.7/site-packages/django/core/mail/backends/smtp.py", line 125, '+
            'in _send ---     message = email_message.message() ---   File "/srv/'+
            'webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/'+
            'site-packages/django/core/mail/message.py", line 303, in message '+
            '---     msg[\'Subject\'] = self.subject ---   File "/srv/webapps/'+
            'bigbasket.com/virtualenvs/bigbasket1.11/local/lib/python2.7/'+
            'site-packages/django/core/mail/message.py", line 217, in __setitem__ '+
            '---     name, val = forbid_multi_line_headers(name, val, '+
            'self.encoding) ---   File "/srv/webapps/bigbasket.com/virtualenvs/'+
            'bigbasket1.11/local/lib/python2.7/site-packages/django/core/mail/'+
            'message.py", line 92, in forbid_multi_line_headers ---     '+
            'raise BadHeaderError("Header values can\'t contain newlines (got %r '+
            'for header %r)" % (val, name)) --- BadHeaderError: Header values '+
            'can\'t contain newlines (got u\'Error in converting into small '+
            'order: 46132322,  Traceback (most recent call last):\\n  File '+
            '"/srv/webapps/bigbasket.com/BigBasket/order/models.py", line 9297, '+
            'in check_and_move_small_order\\n    ret_dict = self.change_hub('+
            'new_hub, self.slot.slot_date, new_slot, change_hub_flag='+
            'change_hub_flag)\\n  File "/srv/webapps/bigbasket.com/BigBasket/order/'+
            'models.py", line 8678, in change_hub\\n    slot=self.slot.slot_time)'+
            '.restrict_orderpick_by_vanassign\\n  File "/srv/webapps/bigbasket.com/'+
            'virtualenvs/bigbasket1.11/local/lib/python2.7/site-packages/django/db/'+
            'models/manager.py", line 85, in manager_method\\n    return '+
            'getattr(self.get_queryset(), name)(*args, **kwargs)\\n  File '+
            '"/srv/webapps/bigbasket.com/virtualenvs/bigbasket1.11/local/lib/'+
            'python2.7/site-packages/django/db/models/query.py", line 379, in '+
            'get\\n    self.model._meta.object_name\\nDoesNotExist: SlotHubCapacity '+
            'matching query does not exist.\\n\' for header u\'Subject\') --- ')
        assert_equal('BadHeaderError', err_name)
        assert_equal('c29f4da45781e7a534a14d741abc38f22df8791d', fingerprint)
    end
end
