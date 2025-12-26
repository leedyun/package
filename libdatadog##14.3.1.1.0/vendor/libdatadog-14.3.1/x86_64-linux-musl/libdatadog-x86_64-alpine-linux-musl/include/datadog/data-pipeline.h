// Copyright 2021-Present Datadog, Inc. https://www.datadoghq.com/
// SPDX-License-Identifier: Apache-2.0


#ifndef DDOG_DATA_PIPELINE_H
#define DDOG_DATA_PIPELINE_H

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include "common.h"

/**
 * Default value for the timeout field in milliseconds.
 */
#define ddog_Endpoint_DEFAULT_TIMEOUT 3000

/**
 * TraceExporterInputFormat represents the format of the input traces.
 * The input format can be either Proxy or V0.4, where V0.4 is the default.
 */
typedef enum ddog_TraceExporterInputFormat {
  /**
   * Proxy format is used when the traces are to be sent to the agent without processing them.
   * The whole payload is sent as is to the agent.
   */
  DDOG_TRACE_EXPORTER_INPUT_FORMAT_PROXY,
  DDOG_TRACE_EXPORTER_INPUT_FORMAT_V04,
} ddog_TraceExporterInputFormat;

/**
 * TraceExporterOutputFormat represents the format of the output traces.
 * The output format can be either V0.4 or v0.7, where V0.4 is the default.
 */
typedef enum ddog_TraceExporterOutputFormat {
  DDOG_TRACE_EXPORTER_OUTPUT_FORMAT_V04,
  DDOG_TRACE_EXPORTER_OUTPUT_FORMAT_V07,
} ddog_TraceExporterOutputFormat;

/**
 * The TraceExporter ingest traces from the tracers serialized as messagepack and forward them to
 * the agent while applying some transformation.
 *
 * # Proxy
 * If the input format is set as `Proxy`, the exporter will forward traces to the agent without
 * deserializing them.
 *
 * # Features
 * When the input format is set to `V04` the TraceExporter will deserialize the traces and perform
 * some operation before sending them to the agent. The available operations are described below.
 *
 * ## V07 Serialization
 * The Trace exporter can serialize the traces to V07 before sending them to the agent.
 *
 * ## Stats computation
 * The Trace Exporter can compute stats on traces. In this case the trace exporter will start
 * another task to send stats when a time bucket expire. When this feature is enabled the
 * TraceExporter drops all spans that may not be sampled by the agent.
 */
typedef struct ddog_TraceExporter ddog_TraceExporter;

/**
 * Holds the raw parts of a Rust Vec; it should only be created from Rust,
 * never from C.
 */
typedef struct ddog_Vec_U8 {
  const uint8_t *ptr;
  uintptr_t len;
  uintptr_t capacity;
} ddog_Vec_U8;

/**
 * Please treat this as opaque; do not reach into it, and especially don't
 * write into it! The most relevant APIs are:
 * * `ddog_Error_message`, to get the message as a slice.
 * * `ddog_Error_drop`.
 */
typedef struct ddog_Error {
  /**
   * This is a String stuffed into the vec.
   */
  struct ddog_Vec_U8 message;
} ddog_Error;

typedef enum ddog_Option_Error_Tag {
  DDOG_OPTION_ERROR_SOME_ERROR,
  DDOG_OPTION_ERROR_NONE_ERROR,
} ddog_Option_Error_Tag;

typedef struct ddog_Option_Error {
  ddog_Option_Error_Tag tag;
  union {
    struct {
      struct ddog_Error some;
    };
  };
} ddog_Option_Error;

typedef struct ddog_Option_Error ddog_MaybeError;

typedef struct ddog_Slice_CChar {
  /**
   * Should be non-null and suitably aligned for the underlying type. It is
   * allowed but not recommended for the pointer to be null when the len is
   * zero.
   */
  const char *ptr;
  /**
   * The number of elements (not bytes) that `.ptr` points to. Must be less
   * than or equal to [isize::MAX].
   */
  uintptr_t len;
} ddog_Slice_CChar;

/**
 * Use to represent strings -- should be valid UTF-8.
 */
typedef struct ddog_Slice_CChar ddog_CharSlice;

typedef struct ddog_Slice_U8 {
  /**
   * Should be non-null and suitably aligned for the underlying type. It is
   * allowed but not recommended for the pointer to be null when the len is
   * zero.
   */
  const uint8_t *ptr;
  /**
   * The number of elements (not bytes) that `.ptr` points to. Must be less
   * than or equal to [isize::MAX].
   */
  uintptr_t len;
} ddog_Slice_U8;

/**
 * Use to represent bytes -- does not need to be valid UTF-8.
 */
typedef struct ddog_Slice_U8 ddog_ByteSlice;

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

/**
 * Create a new TraceExporter instance.
 *
 * # Arguments
 *
 * * `out_handle` - The handle to write the TraceExporter instance in.
 * * `url` - The URL of the Datadog Agent to communicate with.
 * * `tracer_version` - The version of the client library.
 * * `language` - The language of the client library.
 * * `language_version` - The version of the language of the client library.
 * * `language_interpreter` - The interpreter of the language of the client library.
 * * `hostname` - The hostname of the application, used for stats aggregation
 * * `env` - The environment of the application, used for stats aggregation
 * * `version` - The version of the application, used for stats aggregation
 * * `service` - The service name of the application, used for stats aggregation
 * * `input_format` - The input format of the traces. Setting this to Proxy will send the trace
 *   data to the Datadog Agent as is.
 * * `output_format` - The output format of the traces to send to the Datadog Agent. If using the
 *   Proxy input format, this should be set to format if the trace data that will be passed through
 *   as is.
 * * `agent_response_callback` - The callback into the client library that the TraceExporter uses
 *   for updated Agent JSON responses.
 */
ddog_MaybeError ddog_trace_exporter_new(struct ddog_TraceExporter **out_handle,
                                        ddog_CharSlice url,
                                        ddog_CharSlice tracer_version,
                                        ddog_CharSlice language,
                                        ddog_CharSlice language_version,
                                        ddog_CharSlice language_interpreter,
                                        ddog_CharSlice hostname,
                                        ddog_CharSlice env,
                                        ddog_CharSlice version,
                                        ddog_CharSlice service,
                                        enum ddog_TraceExporterInputFormat input_format,
                                        enum ddog_TraceExporterOutputFormat output_format,
                                        bool compute_stats,
                                        void (*agent_response_callback)(const char*));

/**
 * Free the TraceExporter instance.
 *
 * # Arguments
 *
 * * handle - The handle to the TraceExporter instance.
 */
void ddog_trace_exporter_free(struct ddog_TraceExporter *handle);

/**
 * Send traces to the Datadog Agent.
 *
 * # Arguments
 *
 * * `handle` - The handle to the TraceExporter instance.
 * * `trace` - The traces to send to the Datadog Agent in the input format used to create the
 *   TraceExporter.
 * * `trace_count` - The number of traces to send to the Datadog Agent.
 */
ddog_MaybeError ddog_trace_exporter_send(const struct ddog_TraceExporter *handle,
                                         ddog_ByteSlice trace,
                                         uintptr_t trace_count);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  /* DDOG_DATA_PIPELINE_H */
