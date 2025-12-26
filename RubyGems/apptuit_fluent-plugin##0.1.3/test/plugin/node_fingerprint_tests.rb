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


class NodeFingerprintTests

    def test_fp_not_a_stacktrace(fingerprinter)
      result = fingerprinter.fingerprint_nodejs(
          'User and his address details in appDataDynamic call {"user_type":"member","user_id":6763239,"selected_address":{"nick":"","id":"102840374","lat":10.96460749142318,"lng":76.9185347010498,"area":"Perur Chettipalayam, Coimbatore, Tamil Nadu","city_name":"Coimbatore","city_id":12,"city_short_name":"CBE","pin":641010,"is_partial":false,"is_default":true,"residential_complex":"HAD nagar","first_name":"Manhar","last_name":"JS","contact_area":"Perur Chettipalayam, Coimbatore, Tamil Nadu","contact_no":"8489947000","landmark":"nest to GVD Nagar arch","address_1":"oriental Inframart","address_2":"perur Kovaipudur main road","is_express":true,"shadow_city_id":12}}')
      assert_equal(nil,result)
    end
  
    def test_fp_basic(fingerprinter)
      err_name, fingerprint, essence, stack = fingerprinter.fingerprint_nodejs(
          'TypeError: First argument must be a string, Buffer, ArrayBuffer, Array, or array-like object.  ---      at fromObject (buffer.js:262:9)  ---      at Function.Buffer.from (buffer.js:101:10)  ---      at new Buffer (buffer.js:80:17)  ---      at Object.module.exports.decodeBase64 (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/bb-commons/utils/index.js:38:20)  ---      at module.exports.onAutosearchMapi (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/routes/index.js:96:27)  ---      at Layer.handle [as handle_request] (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/layer.js:95:5)  ---      at next (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/route.js:131:13)  ---      at Route.dispatch (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/route.js:112:3)  ---      at Layer.handle [as handle_request] (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/layer.js:95:5)  ---      at /srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:277:22  ---      at param (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:349:14)  ---      at param (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:365:14)  ---      at param (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:365:14)  ---      at Function.process_params (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:410:3)  ---      at next (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:271:10)  ---      at module.exports.AutocompleteMiddleware (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/routes/middleware.js:8:5)  ---      at Layer.handle [as handle_request] (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/layer.js:95:5)  ---      at trim_prefix (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:312:13)  ---      at /srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:280:7  ---      at Function.process_params (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:330:12)  ---      at next (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/express/lib/router/index.js:271:10)  ---      at module.exports.AggregatedRequestMiddleware (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/bb-commons/middlewares/aggregated_request_middleware.js:19:5) ')
      assert_equal('TypeError', err_name)
      assert_equal('c791f8a9c9e3f2df435a2852f32a42915dfe5548', fingerprint)
    end

    def test_fp_short(fingerprinter)
      err_name, fingerprint, essence, stack = fingerprinter.fingerprint_nodejs(
          'TypeError: Cannot read property \'Hub\' of null ---     at async (/srv/webapps/bigbasket.com/BigBasket/services/clan/node_modules/bb-commons/restWrappers/memberStores.js:422:31) ---     at tryBlock (/srv/webapps/bigbasket.com/BigBasket/services/clan/node_modules/asyncawait/src/async/fiberManager.js:39:33) ---     at runInFiber (/srv/webapps/bigbasket.com/BigBasket/services/clan/node_modules/asyncawait/src/async/fiberManager.js:26:9) ')
      # print(err_name + ":" + fingerprint)
      assert_equal('TypeError', err_name)
      assert_equal('dce7fa69b17a121ffeb250c9528fda048fa59ed7', fingerprint)
    end

    def test_fp_mulitline_message(fingerprinter)
      log_message = 'SolrError: {"responseHeader":{"zkConnected":true,"status":400,"QTime":1,"params":{"qt":"dismax_tc","fq":"parent_locality_283_i:1 AND text:()","wt":"json"}},"error":{"metadata":["error-class","org.apache.solr.common.SolrException","root-error-class","org.apache.solr.parser.ParseException"],"msg":"org.apache.solr.search.SyntaxError: Cannot parse \'parent_locality_283_i:1 AND text:()\': Encountered \" \")\" \") \"\" at line 1, column 34.\nWas expecting one of:\n    <NOT> ...\n    \"+\" ...\n    \"-\" ...\n    <BAREOPER> ...\n    \"(\" ...\n    \"*\" ...\n    <QUOTED> ...\n    <TERM> ...\n    <PREFIXTERM> ...\n    <WILDTERM> ...\n    <REGEXPTERM> ...\n    \"[\" ...\n    \"{\" ...\n    <LPARAMS> ...\n    \"filter(\" ...\n    <NUMBER> ...\n    <TERM> ...\n    ","code":400}}\n --- Request URL: http://solrcloud.bigbasket.com:8983/solr/bbconfig/select?fq=parent_locality_283_i:1%20AND%20text:()&qt=dismax_tc&wt=json\n --- Request method: GET\n --- Status code: 400 - Bad Request\n --- Request headers: \n --- accept: application/json; charset=utf-8\n --- host: solrcloud.bigbasket.com:8983\n --- Response headers: \n --- date: Thu, 10 May 2018 06:17:03 GMT\n --- content-type: text/plain;charset=utf-8\n --- content-length: 766\n --- connection: close\n --- cache-control: no-cache, no-store\n --- pragma: no-cache\n --- expires: Sat, 01 Jan 2000 01:00:00 GMT\n --- last-modified: Thu, 10 May 2018 06:17:03 GMT\n --- etag: "16348b22089" ---     at IncomingMessage.<anonymous> (/srv/webapps/bigbasket.com/bb-solr-client/lib/solr.js:943:19) ---     at emitNone (events.js:91:20) ---     at IncomingMessage.emit (events.js:185:7) ---     at endReadableNT (_stream_readable.js:974:12) ---     at _combinedTickCallback (internal/process/next_tick.js:74:11) ---     at process._tickDomainCallback (internal/process/next_tick.js:122:9) '
      err_name, fingerprint, essence, stack = fingerprinter.fingerprint_nodejs(
        log_message)
      #print(err_name + ":" + fingerprint)
      #rint(log_message)
      #print(essence)
      assert_equal('SolrError', err_name)
      assert_equal('9463b56bcf92930574cd9aa1be489ebe97815d4a', fingerprint)
    end
  
    def test_fp_json_wrapped(fingerprinter)
      err_name, fingerprint, essence, stack = fingerprinter.fingerprint_nodejs(
          'Aerospike cache miss for Key::1:nsearch.psauto.cG1eZAYhYyIxNSFxJ3NveWEgc2EibWQLImx0TQolI21yaSEibmZD {"message":"AEROSPIKE_ERR_RECORD_NOT_FOUND","name":"AerospikeError","code":2,"func":"as_event_command_parse_result","file":"src/main/aerospike/as_event.c","line":619,"stack":"AerospikeError: AEROSPIKE_ERR_RECORD_NOT_FOUND    at Function.AerospikeError.fromASError (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/aerospike/lib/aerospike_error.js:118:10)    at Client.DefaultCallbackHandler [as callbackHandler] (/srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/aerospike/lib/client.js:161:72)    at /srv/webapps/bigbasket.com/BigBasket/services/nodeAutosearch/node_modules/aerospike/lib/client.js:1532:19"}')
      # print(err_name + ":" + fingerprint)
      assert_equal('AerospikeError', err_name)
      assert_equal('b0e6ae45ba72ae1aa3b4bfd6f0bd34608d4b3dd3', fingerprint)
    end
  
    def test_fp_json_with_at(fingerprinter)
      err_name, fingerprint, essence, stack = fingerprinter.fingerprint_nodejs(
          'Error in increasing product quantity {"message":"Error in updating the cartItemQty. Should not happen","stack":"Error: Error in updating the cartItemQty. Should not happen    at /srv/webapps/bigbasket.com/BigBasket/services/cart/controllers/BasketOperations.js:59:23    at tryBlock (/srv/webapps/bigbasket.com/BigBasket/services/cart/node_modules/asyncawait/src/async/fiberManager.js:39:33)    at runInFiber (/srv/webapps/bigbasket.com/BigBasket/services/cart/node_modules/asyncawait/src/async/fiberManager.js:26:9)"}')
      # print(err_name + ":" + fingerprint)
      assert_equal('Error', err_name)
      assert_equal('0e3a7d113bf9787cfa57d2fc8d8f8e43e62ec5be', fingerprint)
    end
end
