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


class JavaFingerprintTests

    def test_baseline(fingerprinter)
      err_name, fingerprint, essence, stack = fingerprinter.fingerprint_java(
        'com.bigbasket.po.exceptions.BadRequestException: Invalid Sku id. Sku doesn\'t belong to this city - 10000200\n'+
        '\tat com.bigbasket.po.services.po.impl.ProductProcessor.lambda$fetchProductsWithFIandRI$22(ProductProcessor.java:223)\n'+
        '\tat com.bigbasket.po.common.RxUtil.lambda$zipFlatMap2$1(RxUtil.java:23)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableFlatMap$MergeSubscriber.onNext(FlowableFlatMap.java:132)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableZip$ZipCoordinator.drain(FlowableZip.java:250)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableZip$ZipSubscriber.onNext(FlowableZip.java:383)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableFlatMap$MergeSubscriber.drainLoop(FlowableFlatMap.java:500)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableFlatMap$MergeSubscriber.drain(FlowableFlatMap.java:366)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableFlatMap$InnerSubscriber.onNext(FlowableFlatMap.java:662)\n'+
        '\tat io.reactivex.internal.subscriptions.DeferredScalarSubscription.complete(DeferredScalarSubscription.java:118)\n'+
        '\tat io.reactivex.internal.operators.single.SingleToFlowable$SingleToFlowableObserver.onSuccess(SingleToFlowable.java:63)\n'+
        '\tat io.reactivex.internal.operators.single.SingleJust.subscribeActual(SingleJust.java:30)\n'+
        '\tat io.reactivex.Single.subscribe(Single.java:3394)\n'+
        '\tat io.reactivex.internal.operators.single.SingleToFlowable.subscribeActual(SingleToFlowable.java:37)\n'+
        '\tat io.reactivex.Flowable.subscribe(Flowable.java:14409)\n'+
        '\tat io.reactivex.Flowable.subscribe(Flowable.java:14356)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableFlatMap$MergeSubscriber.onNext(FlowableFlatMap.java:163)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableZip$ZipCoordinator.drain(FlowableZip.java:250)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableZip$ZipSubscriber.onNext(FlowableZip.java:383)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableRepeat$RepeatSubscriber.onNext(FlowableRepeat.java:65)\n'+
        '\tat io.reactivex.internal.subscriptions.DeferredScalarSubscription.complete(DeferredScalarSubscription.java:133)\n'+
        '\tat io.reactivex.internal.operators.single.SingleToFlowable$SingleToFlowableObserver.onSuccess(SingleToFlowable.java:63)\n'+
        '\tat io.reactivex.internal.operators.single.SingleCache.subscribeActual(SingleCache.java:59)\n'+
        '\tat io.reactivex.Single.subscribe(Single.java:3394)\n'+
        '\tat io.reactivex.internal.operators.single.SingleToFlowable.subscribeActual(SingleToFlowable.java:37)\n'+
        '\tat io.reactivex.Flowable.subscribe(Flowable.java:14409)\n'+
        '\tat io.reactivex.Flowable.subscribe(Flowable.java:14356)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableRepeat$RepeatSubscriber.subscribeNext(FlowableRepeat.java:100)\n'+
        '\tat io.reactivex.internal.operators.flowable.FlowableRepeat$RepeatSubscriber.onComplete(FlowableRepeat.java:79)\n'+
        '\tat io.reactivex.internal.subscriptions.DeferredScalarSubscription.complete(DeferredScalarSubscription.java:135)\n'+
        '\tat io.reactivex.internal.operators.single.SingleToFlowable$SingleToFlowableObserver.onSuccess(SingleToFlowable.java:63)\n'+
        '\tat io.reactivex.internal.operators.single.SingleCache.onSuccess(SingleCache.java:134)\n'+
        '\tat io.reactivex.internal.operators.single.SingleFlatMap$SingleFlatMapCallback$FlatMapSingleObserver.onSuccess(SingleFlatMap.java:111)\n'+
        '\tat io.reactivex.internal.operators.single.SingleMap$MapSingleObserver.onSuccess(SingleMap.java:64)\n'+
        '\tat io.reactivex.internal.operators.single.SingleFlatMap$SingleFlatMapCallback$FlatMapSingleObserver.onSuccess(SingleFlatMap.java:111)\n'+
        '\tat io.reactivex.internal.operators.single.SingleJust.subscribeActual(SingleJust.java:30)\n'+
        '\tat io.reactivex.Single.subscribe(Single.java:3394)\n'+
        '\tat io.reactivex.internal.operators.single.SingleFlatMap$SingleFlatMapCallback.onSuccess(SingleFlatMap.java:84)\n'+
        '\tat io.vertx.reactivex.core.impl.AsyncResultSingle.lambda$subscribeActual$0(AsyncResultSingle.java:46)\n'+
        '\tat io.vertx.ext.sql.SQLClient.lambda$null$5(SQLClient.java:129)\n'+
        '\tat io.vertx.ext.asyncsql.impl.AsyncSQLConnectionImpl.close(AsyncSQLConnectionImpl.java:190)\n'+
        '\tat io.vertx.ext.sql.SQLClient.lambda$null$6(SQLClient.java:125)\n'+
        '\tat io.vertx.ext.asyncsql.impl.AsyncSQLConnectionImpl.lambda$handleAsyncQueryResultToResultSet$12(AsyncSQLConnectionImpl.java:319)\n'+
        '\tat io.vertx.ext.asyncsql.impl.ScalaUtils$3.apply(ScalaUtils.java:91)\n'+
        '\tat io.vertx.ext.asyncsql.impl.ScalaUtils$3.apply(ScalaUtils.java:87)\n'+
        '\tat scala.concurrent.impl.CallbackRunnable.run(Promise.scala:60)\n'+
        '\tat io.vertx.ext.asyncsql.impl.VertxEventLoopExecutionContext.lambda$execute$0(VertxEventLoopExecutionContext.java:59)\n'+
        '\tat io.vertx.core.impl.ContextImpl.lambda$wrapTask$2(ContextImpl.java:339)\n'+
        '\tat io.netty.util.concurrent.AbstractEventExecutor.safeExecute(AbstractEventExecutor.java:163)\n'+
        '\tat io.netty.util.concurrent.SingleThreadEventExecutor.runAllTasks(SingleThreadEventExecutor.java:404)\n'+
        '\tat io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:463)\n'+
        '\tat io.netty.util.concurrent.SingleThreadEventExecutor$5.run(SingleThreadEventExecutor.java:886)\n'+
        '\tat io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)\n'+
        '\tat java.lang.Thread.run(Thread.java:748)\n'
      )
      assert_equal('com.bigbasket.po.exceptions.BadRequestException', err_name)
      assert_equal('843c0e208a44e24bb73d926bf5af706893c91e75', fingerprint)
    end
  
    def test_nested_basic(fingerprinter)
      err_name, fingerprint, essence, stack = fingerprinter.fingerprint_java(
        'java.util.concurrent.ExecutionException: 3\n'+
        '\tat fingerprinter.Main.first(Main.java:17)\n'+
        '\tat fingerprinter.Main.main(Main.java:10)\n'+
        'Caused by: java.util.concurrent.ExecutionException: 2\n'+
        '\tat fingerprinter.Main.second(Main.java:33)\n'+
        '\tat fingerprinter.Main.bloatSecond1(Main.java:26)\n'+
        '\tat fingerprinter.Main.bloatSecond(Main.java:22)\n'+
        '\tat fingerprinter.Main.first(Main.java:15)\n'+
        '\t... 1 more\n'+
        'Caused by: java.io.IOException: 1\n'+
        '\tat fingerprinter.Main.third(Main.java:46)\n'+
        '\tat fingerprinter.Main.bloatThird1(Main.java:42)\n'+
        '\tat fingerprinter.Main.bloatThird(Main.java:38)\n'+
        '\tat fingerprinter.Main.second(Main.java:31)\n'+
        '\t... 4 more\n'
      )
      assert_equal('java.util.concurrent.ExecutionException', err_name)
      assert_equal('d3b6a4b1f4b389b2f2778b54b1463e66f8803841', fingerprint)
    end
  
      def test_fill_nostacktrace_nested_exception(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_java(
            'org.elasticsearch.transport.RemoteTransportException: [13.232.79.206][10.0.0.14:9300][indices:data/read/search[phase/query]]\n'+
            'Caused by: org.elasticsearch.index.query.QueryShardException: Failed to parse query ["connectreema@gmail.com"  AND "Reserve" AND 40046547"]\n'+
            '\tat org.elasticsearch.index.query.QueryStringQueryBuilder.doToQuery(QueryStringQueryBuilder.java:1044) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.AbstractQueryBuilder.toQuery(AbstractQueryBuilder.java:98) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.BoolQueryBuilder.addBooleanClauses(BoolQueryBuilder.java:404) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.BoolQueryBuilder.doToQuery(BoolQueryBuilder.java:378) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.AbstractQueryBuilder.toQuery(AbstractQueryBuilder.java:98) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryShardContext.lambda$toQuery$2(QueryShardContext.java:305) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryShardContext.toQuery(QueryShardContext.java:317) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryShardContext.toQuery(QueryShardContext.java:304) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.parseSource(SearchService.java:724) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.createContext(SearchService.java:575) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.createAndPutContext(SearchService.java:551) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.executeQueryPhase(SearchService.java:347) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService$2.onResponse(SearchService.java:333) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService$2.onResponse(SearchService.java:329) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService$3.doRun(SearchService.java:1019) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.ThreadContext$ContextPreservingAbstractRunnable.doRun(ThreadContext.java:723) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.AbstractRunnable.run(AbstractRunnable.java:37) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.TimedRunnable.doRun(TimedRunnable.java:41) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.AbstractRunnable.run(AbstractRunnable.java:37) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149) ~[?:1.8.0_181]\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624) ~[?:1.8.0_181]\n'+
            '\tat java.lang.Thread.run(Thread.java:748) [?:1.8.0_181]\n'+
            'Caused by: org.elasticsearch.common.io.stream.NotSerializableExceptionWrapper: parse_exception: Cannot parse \'"connectreema@gmail.com"  AND "Reserve" AND 40046547"\': Lexical error at line 1, column 54.  Encountered: <EOF> after : ""\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParserBase.parse(QueryParserBase.java:114) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.elasticsearch.index.search.QueryStringQueryParser.parse(QueryStringQueryParser.java:793) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryStringQueryBuilder.doToQuery(QueryStringQueryBuilder.java:1042) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.AbstractQueryBuilder.toQuery(AbstractQueryBuilder.java:98) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.BoolQueryBuilder.addBooleanClauses(BoolQueryBuilder.java:404) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.BoolQueryBuilder.doToQuery(BoolQueryBuilder.java:378) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.AbstractQueryBuilder.toQuery(AbstractQueryBuilder.java:98) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryShardContext.lambda$toQuery$2(QueryShardContext.java:305) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryShardContext.toQuery(QueryShardContext.java:317) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryShardContext.toQuery(QueryShardContext.java:304) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.parseSource(SearchService.java:724) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.createContext(SearchService.java:575) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.createAndPutContext(SearchService.java:551) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.executeQueryPhase(SearchService.java:347) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService$2.onResponse(SearchService.java:333) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService$2.onResponse(SearchService.java:329) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService$3.doRun(SearchService.java:1019) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.ThreadContext$ContextPreservingAbstractRunnable.doRun(ThreadContext.java:723) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.AbstractRunnable.run(AbstractRunnable.java:37) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.TimedRunnable.doRun(TimedRunnable.java:41) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.AbstractRunnable.run(AbstractRunnable.java:37) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149) ~[?:1.8.0_181]\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624) ~[?:1.8.0_181]\n'+
            '\tat java.lang.Thread.run(Thread.java:748) ~[?:1.8.0_181]\n'+
            'Caused by: org.elasticsearch.common.io.stream.NotSerializableExceptionWrapper: token_mgr_error: Lexical error at line 1, column 54.  Encountered: <EOF> after : ""\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParserTokenManager.getNextToken(QueryParserTokenManager.java:1119) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParser.jj_scan_token(QueryParser.java:822) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParser.jj_3R_4(QueryParser.java:692) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParser.jj_3_3(QueryParser.java:714) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParser.jj_2_3(QueryParser.java:660) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParser.Clause(QueryParser.java:324) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParser.Query(QueryParser.java:303) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParser.TopLevelQuery(QueryParser.java:215) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.apache.lucene.queryparser.classic.QueryParserBase.parse(QueryParserBase.java:109) ~[lucene-queryparser-7.4.0.jar:7.4.0 9060ac689c270b02143f375de0348b7f626adebc - jpountz - 2018-06-18 16:52:15]\n'+
            '\tat org.elasticsearch.index.search.QueryStringQueryParser.parse(QueryStringQueryParser.java:793) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryStringQueryBuilder.doToQuery(QueryStringQueryBuilder.java:1042) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.AbstractQueryBuilder.toQuery(AbstractQueryBuilder.java:98) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.BoolQueryBuilder.addBooleanClauses(BoolQueryBuilder.java:404) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.BoolQueryBuilder.doToQuery(BoolQueryBuilder.java:378) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.AbstractQueryBuilder.toQuery(AbstractQueryBuilder.java:98) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryShardContext.lambda$toQuery$2(QueryShardContext.java:305) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryShardContext.toQuery(QueryShardContext.java:317) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.index.query.QueryShardContext.toQuery(QueryShardContext.java:304) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.parseSource(SearchService.java:724) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.createContext(SearchService.java:575) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.createAndPutContext(SearchService.java:551) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService.executeQueryPhase(SearchService.java:347) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService$2.onResponse(SearchService.java:333) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService$2.onResponse(SearchService.java:329) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.search.SearchService$3.doRun(SearchService.java:1019) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.ThreadContext$ContextPreservingAbstractRunnable.doRun(ThreadContext.java:723) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.AbstractRunnable.run(AbstractRunnable.java:37) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.TimedRunnable.doRun(TimedRunnable.java:41) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat org.elasticsearch.common.util.concurrent.AbstractRunnable.run(AbstractRunnable.java:37) ~[elasticsearch-6.4.2.jar:6.4.2]\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149) ~[?:1.8.0_181]\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624) ~[?:1.8.0_181]\n'+
            '\tat java.lang.Thread.run(Thread.java:748) ~[?:1.8.0_181]\n'+
            '\n')
        assert_equal('org.elasticsearch.transport.RemoteTransportException', err_name)
        assert_equal('12aa95426a5f03e2760af8dc6096203bf30a3fdc', fingerprint)
      end
    
      def test_otsd_exception(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_java(
            'net.opentsdb.tsd.TokenVerificationException: Failed Verification : token\'s orgId does not match\n'+
            '\tat net.opentsdb.utils.TenantUtil.validateTokenData(TenantUtil.java:233) ~[tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat net.opentsdb.utils.TenantUtil.getValidatedToken(TenantUtil.java:136) ~[tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat net.opentsdb.utils.TenantUtil.getValidatedTokenInfo(TenantUtil.java:127) ~[tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat net.opentsdb.tsd.TenantRpc.doValidate(TenantRpc.java:167) [tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat net.opentsdb.tsd.TenantRpc.validateTokenOrgId(TenantRpc.java:160) [tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat net.opentsdb.tsd.TenantRpc.execute(TenantRpc.java:52) [tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat net.opentsdb.tsd.RpcHandler.handleHttpQuery(RpcHandler.java:348) [tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat net.opentsdb.tsd.RpcHandler.messageReceived(RpcHandler.java:174) [tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.handleUpstream(SimpleChannelUpstreamHandler.java:70) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.handler.timeout.IdleStateAwareChannelUpstreamHandler.handleUpstream(IdleStateAwareChannelUpstreamHandler.java:36) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline$DefaultChannelHandlerContext.sendUpstream(DefaultChannelPipeline.java:791) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.messageReceived(SimpleChannelUpstreamHandler.java:124) [netty-3.9.4.Final.jar:na]\n'+
            '\tat net.opentsdb.tsd.PipelineFactory$DetectHttpOrRpc$3.messageReceived(PipelineFactory.java:235) [tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.handleUpstream(SimpleChannelUpstreamHandler.java:70) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline$DefaultChannelHandlerContext.sendUpstream(DefaultChannelPipeline.java:791) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.messageReceived(SimpleChannelUpstreamHandler.java:124) [netty-3.9.4.Final.jar:na]\n'+
            '\tat net.opentsdb.tsd.PipelineFactory$DetectHttpOrRpc$2.messageReceived(PipelineFactory.java:217) [tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.handleUpstream(SimpleChannelUpstreamHandler.java:70) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline$DefaultChannelHandlerContext.sendUpstream(DefaultChannelPipeline.java:791) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.messageReceived(SimpleChannelUpstreamHandler.java:124) [netty-3.9.4.Final.jar:na]\n'+
            '\tat net.opentsdb.tsd.PipelineFactory$DetectHttpOrRpc$1.messageReceived(PipelineFactory.java:185) [tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.handleUpstream(SimpleChannelUpstreamHandler.java:70) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline$DefaultChannelHandlerContext.sendUpstream(DefaultChannelPipeline.java:791) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.handler.timeout.IdleStateHandler.messageReceived(IdleStateHandler.java:294) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.handleUpstream(SimpleChannelUpstreamHandler.java:70) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline$DefaultChannelHandlerContext.sendUpstream(DefaultChannelPipeline.java:791) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.handler.codec.http.HttpContentEncoder.messageReceived(HttpContentEncoder.java:82) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelHandler.handleUpstream(SimpleChannelHandler.java:88) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline$DefaultChannelHandlerContext.sendUpstream(DefaultChannelPipeline.java:791) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.handler.codec.http.HttpContentDecoder.messageReceived(HttpContentDecoder.java:108) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.handleUpstream(SimpleChannelUpstreamHandler.java:70) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline$DefaultChannelHandlerContext.sendUpstream(DefaultChannelPipeline.java:791) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.handler.codec.http.HttpChunkAggregator.messageReceived(HttpChunkAggregator.java:145) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.handleUpstream(SimpleChannelUpstreamHandler.java:70) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline$DefaultChannelHandlerContext.sendUpstream(DefaultChannelPipeline.java:791) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.Channels.fireMessageReceived(Channels.java:296) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.handler.codec.frame.FrameDecoder.unfoldAndFireMessageReceived(FrameDecoder.java:459) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.handler.codec.replay.ReplayingDecoder.callDecode(ReplayingDecoder.java:536) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.handler.codec.replay.ReplayingDecoder.messageReceived(ReplayingDecoder.java:435) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelUpstreamHandler.handleUpstream(SimpleChannelUpstreamHandler.java:70) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline$DefaultChannelHandlerContext.sendUpstream(DefaultChannelPipeline.java:791) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelHandler.messageReceived(SimpleChannelHandler.java:142) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.SimpleChannelHandler.handleUpstream(SimpleChannelHandler.java:88) [netty-3.9.4.Final.jar:na]\n'+
            '\tat net.opentsdb.tsd.ConnectionManager.handleUpstream(ConnectionManager.java:126) [tsdb-2.3.1.jar:5cd3f87]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:564) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.DefaultChannelPipeline.sendUpstream(DefaultChannelPipeline.java:559) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.Channels.fireMessageReceived(Channels.java:268) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.Channels.fireMessageReceived(Channels.java:255) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.socket.nio.NioWorker.read(NioWorker.java:88) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.socket.nio.AbstractNioWorker.process(AbstractNioWorker.java:108) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.socket.nio.AbstractNioSelector.run(AbstractNioSelector.java:318) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.socket.nio.AbstractNioWorker.run(AbstractNioWorker.java:89) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.channel.socket.nio.NioWorker.run(NioWorker.java:178) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.util.ThreadRenamingRunnable.run(ThreadRenamingRunnable.java:108) [netty-3.9.4.Final.jar:na]\n'+
            '\tat org.jboss.netty.util.internal.DeadLockProofWorker$1.run(DeadLockProofWorker.java:42) [netty-3.9.4.Final.jar:na]\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149) [na:1.8.0_151]\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624) [na:1.8.0_151]\n'+
            '\tat java.lang.Thread.run(Thread.java:748) [na:1.8.0_151]\n'
        )
        assert_equal('net.opentsdb.tsd.TokenVerificationException', err_name)
        assert_equal('a1ae1f04b76838fc24c91f9bdc47a01d0103ccea', fingerprint)
      end
    
      def test_old_nesting_sax(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_java(
            'java.util.concurrent.ExecutionException: 3\n'+
            '\tat fingerprinter.Main.first(Main.java:17)\n'+
            '\tat fingerprinter.Main.main(Main.java:10)\n'+
            'Caused by: org.xml.sax.SAXException: 2\n'+
            'java.io.IOException: 1\n'+
            '\tat fingerprinter.Main.second(Main.java:33)\n'+
            '\tat fingerprinter.Main.bloatSecond1(Main.java:26)\n'+
            '\tat fingerprinter.Main.bloatSecond(Main.java:22)\n'+
            '\tat fingerprinter.Main.first(Main.java:15)\n'+
            '\t... 1 more\n'+
            'Caused by: java.io.IOException: 1\n'+
            '\tat fingerprinter.Main.third(Main.java:46)\n'+
            '\tat fingerprinter.Main.bloatThird1(Main.java:42)\n'+
            '\tat fingerprinter.Main.bloatThird(Main.java:38)\n'+
            '\tat fingerprinter.Main.second(Main.java:31)\n'+
            '\t... 4 more\n'
        )
        assert_equal('java.util.concurrent.ExecutionException', err_name)
        assert_equal('c41b63c8736c64f28869c8bd6e5d09d956821c9f', fingerprint)
      end
    
      def test_old_nesting_jaxb(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_java(
            'javax.xml.bind.JAXBException: 3\n'+
            ' - with linked exception:\n'+
            '[org.xml.sax.SAXException: 2\n'+
            'java.io.IOException: 1]\n'+
            '\tat fingerprinter.Main.first(Main.java:17)\n'+
            '\tat fingerprinter.Main.main(Main.java:10)\n'+
            'Caused by: org.xml.sax.SAXException: 2\n'+
            'java.io.IOException: 1\n'+
            '\tat fingerprinter.Main.second(Main.java:33)\n'+
            '\tat fingerprinter.Main.bloatSecond1(Main.java:26)\n'+
            '\tat fingerprinter.Main.bloatSecond(Main.java:22)\n'+
            '\tat fingerprinter.Main.first(Main.java:15)\n'+
            '\t... 1 more\n'+
            'Caused by: java.io.IOException: 1\n'+
            '\tat fingerprinter.Main.third(Main.java:46)\n'+
            '\tat fingerprinter.Main.bloatThird1(Main.java:42)\n'+
            '\tat fingerprinter.Main.bloatThird(Main.java:38)\n'+
            '\tat fingerprinter.Main.second(Main.java:31)\n'+
            '\t... 4 more\n'
        )
        assert_equal('javax.xml.bind.JAXBException', err_name)
        assert_equal('ddbf72ae7d0a14e785eb877d80854e9771a52635', fingerprint)
      end
    
      def test_linenumbers_ignored(fingerprinter)
        err_name1, fingerprint1, essence1, stack = fingerprinter.fingerprint_java(
            'java.net.MalformedURLException: no protocol: asdfasdf\n'+
            '\tat java.net.URL.<init>(URL.java:593)\n'+
            '\tat java.net.URL.<init>(URL.java:490)\n'+
            '\tat java.net.URL.<init>(URL.java:439)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testLineNumbersAreIgnored(ErrorFingerprintTests.java:59)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:23)\n'
        )
        err_name2, fingerprint2, essence2, stack = fingerprinter.fingerprint_java(
            'java.net.MalformedURLException: no protocol: asdfasdf\n'+
            '\tat java.net.URL.<init>(URL.java:593)\n'+
            '\tat java.net.URL.<init>(URL.java:490)\n'+
            '\tat java.net.URL.<init>(URL.java:439)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testLineNumbersAreIgnored(ErrorFingerprintTests.java:65)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:23)\n'
        )
        assert_equal(err_name1, err_name2)
        assert_equal(fingerprint1, fingerprint2)
        assert_equal(essence1, essence2)
      end
    
      def test_circular_ref(fingerprinter)
        circular = fingerprinter.fingerprint_java(
            'fingerprinter.ErrorFingerprintTests$CircularReferenceException\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testCircularReferenceException(ErrorFingerprintTests.java:98)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:25)\n'+
            '\t[CIRCULAR REFERENCE:fingerprinter.ErrorFingerprintTests$CircularReferenceException]\n'
        )
        circular1 = fingerprinter.fingerprint_java(
            'fingerprinter.ErrorFingerprintTests$CircularReferenceException\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testCircularReferenceException(ErrorFingerprintTests.java:99)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:25)\n'+
            '\t[CIRCULAR REFERENCE:fingerprinter.ErrorFingerprintTests$CircularReferenceException]\n'
        )
        assert_equal(circular[1], circular1[1])
      end
    
      def test_exception_in_dynamic_proxy(fingerprinter)
        t1 = fingerprinter.fingerprint_java(
            'java.lang.NullPointerException\n'+
            '\tat fingerprinter.ErrorFingerprintTests$MyProxy.invoke(ErrorFingerprintTests.java:213)\n'+
            '\tat com.sun.proxy.$Proxy0.size(Unknown Source)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._createExceptionInDynamicProxy(ErrorFingerprintTests.java:123)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testExceptionsInADynamicProxy(ErrorFingerprintTests.java:114)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:27)\n'
        )
        t2 = fingerprinter.fingerprint_java(
            'java.lang.NullPointerException\n'+
            '\tat fingerprinter.ErrorFingerprintTests$MyProxy.invoke(ErrorFingerprintTests.java:213)\n'+
            '\tat com.sun.proxy.$Proxy1.size(Unknown Source)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._createExceptionInDynamicProxy(ErrorFingerprintTests.java:123)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testExceptionsInADynamicProxy(ErrorFingerprintTests.java:115)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:27)\n'
        )
        assert_equal(t1[1], t2[1])
      end
    
      def test_reflection_inflation(fingerprinter)
        t1 = fingerprinter.fingerprint_java(
            'java.lang.reflect.InvocationTargetException\n'+
            '\tat sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\n'+
            '\tat sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\n'+
            '\tat sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\n'+
            '\tat java.lang.reflect.Method.invoke(Method.java:498)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._createReflectedException(ErrorFingerprintTests.java:160)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testExceptionsFromReflectionInflation(ErrorFingerprintTests.java:134)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:28)\n'+
            'Caused by: java.lang.IndexOutOfBoundsException: Index: 0, Size: 0\n'+
            '\tat java.util.ArrayList.rangeCheck(ArrayList.java:657)\n'+
            '\tat java.util.ArrayList.get(ArrayList.java:433)\n'+
            '\t... 7 more\n'
        )
        t2 = fingerprinter.fingerprint_java(
            'java.lang.reflect.InvocationTargetException\n'+
            '\tat sun.reflect.GeneratedMethodAccessor1.invoke(Unknown Source)\n'+
            '\tat sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\n'+
            '\tat java.lang.reflect.Method.invoke(Method.java:498)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._createReflectedException(ErrorFingerprintTests.java:160)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testExceptionsFromReflectionInflation(ErrorFingerprintTests.java:148)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:28)\n'+
            'Caused by: java.lang.IndexOutOfBoundsException: Index: 0, Size: 0\n'+
            '\tat java.util.ArrayList.rangeCheck(ArrayList.java:657)\n'+
            '\tat java.util.ArrayList.get(ArrayList.java:433)\n'+
            '\t... 6 more\n'
        )
        assert_equal(t1[1], t2[1])
      end
    
      def test_nested_non_nested(fingerprinter)
        nested = fingerprinter.fingerprint_java(
            'java.lang.RuntimeException: java.net.MalformedURLException: no protocol: asdfasdf\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testNestedException(ErrorFingerprintTests.java:82)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:24)\n'+
            'Caused by: java.net.MalformedURLException: no protocol: asdfasdf\n'+
            '\tat java.net.URL.<init>(URL.java:593)\n'+
            '\tat java.net.URL.<init>(URL.java:490)\n'+
            '\tat java.net.URL.<init>(URL.java:439)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testNestedException(ErrorFingerprintTests.java:77)\n'+
            '\t... 1 more\n')
    
        non_nested = fingerprinter.fingerprint_java(
            'java.lang.RuntimeException\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testNestedException(ErrorFingerprintTests.java:84)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:24)\n')
    
        nested_diff_line = fingerprinter.fingerprint_java(
            'java.lang.RuntimeException: java.net.MalformedURLException: no protocol: asdfasdf\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testNestedException(ErrorFingerprintTests.java:83)\n'+
            '\tat fingerprinter.ErrorFingerprintTests.main(ErrorFingerprintTests.java:24)\n'+
            'Caused by: java.net.MalformedURLException: no protocol: asdfasdf\n'+
            '\tat java.net.URL.<init>(URL.java:593)\n'+
            '\tat java.net.URL.<init>(URL.java:490)\n'+
            '\tat java.net.URL.<init>(URL.java:439)\n'+
            '\tat fingerprinter.ErrorFingerprintTests._testNestedException(ErrorFingerprintTests.java:77)\n'+
            '\t... 1 more\n')
    
        assert_equal(nested[1] == non_nested[1],false)
        assert_equal(nested[1], nested_diff_line[1])
      end
    
    
      def test_multi_line_message(fingerprinter)
        err_name, fingerprint, essence, stack = fingerprinter.fingerprint_java(
            'java.lang.AssertionError: Expect timeout (30000 ms) for matcher: anyOf(regexp(\'(mysql> |> )$\'),regexp(\'Bye\n'+
            'root@0c6b30fe8662:~# \'))\n'+
            '\tat net.sf.expectit.ExpectImpl.expectIn(ExpectImpl.java:69)\n'+
            '\tat net.sf.expectit.ExpectImpl.expectIn(ExpectImpl.java:117)\n'+
            '\tat net.sf.expectit.ExpectImpl.expect(ExpectImpl.java:122)\n'+
            '\tat com.wavemaker.developer.cloud.commons.core.models.AbstractDbShellImpl.executeCommand(AbstractDbShellImpl.java:138)\n'+
            '\tat com.wavemaker.developer.cloud.manager.impl.DBShellManagerImpl.executeDbCommand(DBShellManagerImpl.java:83)\n'+
            '\tat com.wavemaker.developer.cloud.service.impl.DBShellServiceImpl.operate(DBShellServiceImpl.java:63)\n'+
            '\tat com.wavemaker.developer.cloud.controller.DBShellController.operate(DBShellController.java:62)\n'+
            '\tat sun.reflect.GeneratedMethodAccessor375.invoke(Unknown Source)\n'+
            '\tat sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\n'+
            '\tat java.lang.reflect.Method.invoke(Method.java:498)\n'+
            '\tat org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:205)\n'+
            '\tat org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:133)\n'+
            '\tat org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:97)\n'+
            '\tat org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:849)\n'+
            '\tat org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:760)\n'+
            '\tat org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:85)\n'+
            '\tat org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:967)\n'+
            '\tat org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:901)\n'+
            '\tat org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)\n'+
            '\tat org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:872)\n'+
            '\tat javax.servlet.http.HttpServlet.service(HttpServlet.java:661)\n'+
            '\tat org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)\n'+
            '\tat javax.servlet.http.HttpServlet.service(HttpServlet.java:742)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:52)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat com.wavemaker.commons.core.web.filters.EtagFilter.doFilterInternal(EtagFilter.java:42)\n'+
            '\tat org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:320)\n'+
            '\tat org.springframework.security.web.access.intercept.FilterSecurityInterceptor.invoke(FilterSecurityInterceptor.java:127)\n'+
            '\tat org.springframework.security.web.access.intercept.FilterSecurityInterceptor.doFilter(FilterSecurityInterceptor.java:91)\n'+
            '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
            '\tat org.springframework.security.web.access.ExceptionTranslationFilter.doFilter(ExceptionTranslationFilter.java:119)\n'+
            '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
            '\tat org.springframework.security.web.authentication.AnonymousAuthenticationFilter.doFilter(AnonymousAuthenticationFilter.java:111)\n'+
            '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
            '\tat org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestFilter.doFilter(SecurityContextHolderAwareRequestFilter.java:170)\n'+
            '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
            '\tat org.springframework.security.web.authentication.rememberme.RememberMeAuthenticationFilter.doFilter(RememberMeAuthenticationFilter.java:150)\n'+
            '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
            '\tat org.springframework.security.web.header.HeaderWriterFilter.doFilterInternal(HeaderWriterFilter.java:66)\n'+
            '\tat org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)\n'+
            '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
            '\tat org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter.doFilterInternal(WebAsyncManagerIntegrationFilter.java:56)\n'+
            '\tat org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)\n'+
            '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
            '\tat org.springframework.security.web.context.SecurityContextPersistenceFilter.doFilter(SecurityContextPersistenceFilter.java:105)\n'+
            '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
            '\tat org.springframework.security.web.FilterChainProxy.doFilterInternal(FilterChainProxy.java:215)\n'+
            '\tat org.springframework.security.web.FilterChainProxy.doFilter(FilterChainProxy.java:178)\n'+
            '\tat org.springframework.web.filter.DelegatingFilterProxy.invokeDelegate(DelegatingFilterProxy.java:347)\n'+
            '\tat org.springframework.web.filter.DelegatingFilterProxy.doFilter(DelegatingFilterProxy.java:263)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat com.wavemaker.commons.core.web.filters.LoggingFilter.doFilter(LoggingFilter.java:67)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat com.wavemaker.login.client.authservice.filters.ContextUtilFilter.doFilter(ContextUtilFilter.java:91)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat com.wavemaker.login.client.authservice.filters.AuthServiceFilter.doFilter(AuthServiceFilter.java:102)\n'+
            '\tat com.wavemaker.login.client.authservice.filters.TenantHeaderAuthFilter.doFilter(TenantHeaderAuthFilter.java:40)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat ch.qos.logback.classic.selector.servlet.LoggerContextFilter.doFilter(LoggerContextFilter.java:69)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat com.wavemaker.commons.core.web.filters.RequestTaggingFilter.doFilter(RequestTaggingFilter.java:64)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat com.wavemaker.commons.core.web.filters.XSSFilter.doFilter(XSSFilter.java:35)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
            '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
            '\tat org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:198)\n'+
            '\tat org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:96)\n'+
            '\tat org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:140)\n'+
            '\tat org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:80)\n'+
            '\tat org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:624)\n'+
            '\tat org.apache.catalina.valves.RemoteIpValve.invoke(RemoteIpValve.java:677)\n'+
            '\tat org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:87)\n'+
            '\tat org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\n'+
            '\tat org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:799)\n'+
            '\tat org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:66)\n'+
            '\tat org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:861)\n'+
            '\tat org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1455)\n'+
            '\tat org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)\n'+
            '\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)\n'+
            '\tat org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)\n'+
            '\tat java.lang.Thread.run(Thread.java:748)\n'
        )
    
        assert_equal('java.lang.AssertionError', err_name)
        assert_equal('b8b9990c966df3ec30c45f7d9263cf227375122d', fingerprint)
      end
    
    
      def test_heuristic_stacktrace_search(fingerprinter)
          err_name, fingerprint, essence, _  = fingerprinter.fingerprint_java(
              '-- Expect timeout (30000 ms) for matcher: anyOf(regexp(\'(mysql> |> )$\'),regexp(\'Bye\n'+
              'root@9b85248b9cc0:~# \'))\n'+
              'java.lang.AssertionError: Expect timeout (30000 ms) for matcher: anyOf(regexp(\'(mysql> |> )$\'),regexp(\'Bye\n'+
              'root@9b85248b9cc0:~# \'))\n'+
              '\tat net.sf.expectit.ExpectImpl.expectIn(ExpectImpl.java:69)\n'+
              '\tat net.sf.expectit.ExpectImpl.expectIn(ExpectImpl.java:117)\n'+
              '\tat net.sf.expectit.ExpectImpl.expect(ExpectImpl.java:122)\n'+
              '\tat com.wavemaker.developer.cloud.commons.core.models.AbstractDbShellImpl.executeCommand(AbstractDbShellImpl.java:138)\n'+
              '\tat com.wavemaker.developer.cloud.manager.impl.DBShellManagerImpl.executeDbCommand(DBShellManagerImpl.java:83)\n'+
              '\tat com.wavemaker.developer.cloud.service.impl.DBShellServiceImpl.operate(DBShellServiceImpl.java:63)\n'+
              '\tat com.wavemaker.developer.cloud.controller.DBShellController.operate(DBShellController.java:62)\n'+
              '\tat sun.reflect.GeneratedMethodAccessor375.invoke(Unknown Source)\n'+
              '\tat sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\n'+
              '\tat java.lang.reflect.Method.invoke(Method.java:498)\n'+
              '\tat org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:205)\n'+
              '\tat org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:133)\n'+
              '\tat org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:97)\n'+
              '\tat org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:849)\n'+
              '\tat org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:760)\n'+
              '\tat org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:85)\n'+
              '\tat org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:967)\n'+
              '\tat org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:901)\n'+
              '\tat org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)\n'+
              '\tat org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:872)\n'+
              '\tat javax.servlet.http.HttpServlet.service(HttpServlet.java:661)\n'+
              '\tat org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)\n'+
              '\tat javax.servlet.http.HttpServlet.service(HttpServlet.java:742)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:52)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat com.wavemaker.commons.core.web.filters.EtagFilter.doFilterInternal(EtagFilter.java:42)\n'+
              '\tat org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:320)\n'+
              '\tat org.springframework.security.web.access.intercept.FilterSecurityInterceptor.invoke(FilterSecurityInterceptor.java:127)\n'+
              '\tat org.springframework.security.web.access.intercept.FilterSecurityInterceptor.doFilter(FilterSecurityInterceptor.java:91)\n'+
              '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
              '\tat org.springframework.security.web.access.ExceptionTranslationFilter.doFilter(ExceptionTranslationFilter.java:119)\n'+
              '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
              '\tat org.springframework.security.web.authentication.AnonymousAuthenticationFilter.doFilter(AnonymousAuthenticationFilter.java:111)\n'+
              '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
              '\tat org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestFilter.doFilter(SecurityContextHolderAwareRequestFilter.java:170)\n'+
              '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
              '\tat org.springframework.security.web.authentication.rememberme.RememberMeAuthenticationFilter.doFilter(RememberMeAuthenticationFilter.java:150)\n'+
              '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
              '\tat org.springframework.security.web.header.HeaderWriterFilter.doFilterInternal(HeaderWriterFilter.java:66)\n'+
              '\tat org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)\n'+
              '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
              '\tat org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter.doFilterInternal(WebAsyncManagerIntegrationFilter.java:56)\n'+
              '\tat org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)\n'+
              '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
              '\tat org.springframework.security.web.context.SecurityContextPersistenceFilter.doFilter(SecurityContextPersistenceFilter.java:105)\n'+
              '\tat org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)\n'+
              '\tat org.springframework.security.web.FilterChainProxy.doFilterInternal(FilterChainProxy.java:215)\n'+
              '\tat org.springframework.security.web.FilterChainProxy.doFilter(FilterChainProxy.java:178)\n'+
              '\tat org.springframework.web.filter.DelegatingFilterProxy.invokeDelegate(DelegatingFilterProxy.java:347)\n'+
              '\tat org.springframework.web.filter.DelegatingFilterProxy.doFilter(DelegatingFilterProxy.java:263)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat com.wavemaker.commons.core.web.filters.LoggingFilter.doFilter(LoggingFilter.java:67)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat com.wavemaker.login.client.authservice.filters.ContextUtilFilter.doFilter(ContextUtilFilter.java:91)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat com.wavemaker.login.client.authservice.filters.AuthServiceFilter.doFilter(AuthServiceFilter.java:102)\n'+
              '\tat com.wavemaker.login.client.authservice.filters.TenantHeaderAuthFilter.doFilter(TenantHeaderAuthFilter.java:40)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat ch.qos.logback.classic.selector.servlet.LoggerContextFilter.doFilter(LoggerContextFilter.java:69)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat com.wavemaker.commons.core.web.filters.RequestTaggingFilter.doFilter(RequestTaggingFilter.java:64)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat com.wavemaker.commons.core.web.filters.XSSFilter.doFilter(XSSFilter.java:35)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\n'+
              '\tat org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)\n'+
              '\tat org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:198)\n'+
              '\tat org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:96)\n'+
              '\tat org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:140)\n'+
              '\tat org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:80)\n'+
              '\tat org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:624)\n'+
              '\tat org.apache.catalina.valves.RemoteIpValve.invoke(RemoteIpValve.java:677)\n'+
              '\tat org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:87)\n'+
              '\tat org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\n'+
              '\tat org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:799)\n'+
              '\tat org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:66)\n'+
              '\tat org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:861)\n'+
              '\tat org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1455)\n'+
              '\tat org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)\n'+
              '\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)\n'+
              '\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)\n'+
              '\tat org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)\n'+
              '\tat java.lang.Thread.run(Thread.java:748)\n'
          )
    
          assert_equal('java.lang.AssertionError', err_name)
          assert_equal('b8b9990c966df3ec30c45f7d9263cf227375122d', fingerprint)
      end
end
