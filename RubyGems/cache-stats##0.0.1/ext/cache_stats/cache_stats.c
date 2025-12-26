#ifdef __linux__
#define _LARGEFILE_SOURCE
#define _FILE_OFFSET_BITS 64
#endif

#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <ruby.h>
#include <ruby/intern.h>

VALUE cache_stats_class;
uint64_t max_mapping_pages;
int page_size;

typedef struct
{
  uint64_t num_values;
  uint64_t num_set_values;
  char bitmap[0];
} cache_stats_t;

static void set_bit(cache_stats_t *stats, uint64_t position)
{
  stats->bitmap[position / 8] |= (1 << (position % 8));
}

static VALUE cache_stats_index(VALUE self, VALUE index)
{
  long i = NUM2LONG(index);
  cache_stats_t *stats;
  Data_Get_Struct(self, cache_stats_t, stats);
  if (i >= stats->num_values || i < 0)
    return Qnil;
  return (stats->bitmap[i / 8] & (1 << (i % 8))) ? Qtrue : Qfalse;
}

static VALUE cache_stats_total_pages(VALUE self)
{
  cache_stats_t *stats;
  Data_Get_Struct(self, cache_stats_t, stats);
  return LONG2NUM(stats->num_values);
}

static VALUE cache_stats_cached_pages(VALUE self)
{
  cache_stats_t *stats;
  Data_Get_Struct(self, cache_stats_t, stats);
  return LONG2NUM(stats->num_set_values);
}

static VALUE file_cache_stats(VALUE self, VALUE file)
{
  VALUE result = Qnil;
  struct stat file_stats;

  const char *filename = StringValueCStr(file);
  int fd = open(filename, O_RDONLY);
  if (fd < 0) goto out;

  if (fstat(fd, &file_stats)) goto close;

  int file_pages = (file_stats.st_size + page_size - 1) / page_size;

  cache_stats_t *stats = malloc(sizeof(cache_stats_t) + (file_pages + 7) / 8);
  if (!stats) goto close;
  memset(stats, 0, sizeof(cache_stats_t) + (file_pages + 7) / 8);
  stats->num_values = file_pages;

  uint64_t local_max_mapping_pages = max_mapping_pages;
  char *override_env = getenv("CACHE_STATS_MAX_MAPPING_PAGES");
  if (override_env)
  {
    uint64_t override = strtoll(override_env, NULL, 10);
    if (override) local_max_mapping_pages = override;
  }

  size_t vec_size = (file_pages < local_max_mapping_pages) ? file_pages : local_max_mapping_pages;
  char *vec = malloc(vec_size);
  if (!vec) goto close;

  uint64_t offset_pages = 0;
  do
  {
    uint64_t mapping_pages = (file_pages - offset_pages < local_max_mapping_pages) ? file_pages - offset_pages : local_max_mapping_pages;

    void *addr = mmap(NULL, mapping_pages * page_size, PROT_READ, MAP_SHARED, fd, offset_pages * page_size);
    if (addr == MAP_FAILED) goto close;

    if (mincore(addr, mapping_pages * page_size, vec))
    {
      munmap(addr, mapping_pages * page_size);
      goto close;
    }

    for (int i = 0; i < mapping_pages; ++i)
    {
      if (vec[i] & 1)
      {
        stats->num_set_values++;
        set_bit(stats, i + offset_pages);
      }
    }

    munmap(addr, mapping_pages * page_size);
    offset_pages += mapping_pages;
  } while ( offset_pages < file_pages);

  result = Data_Wrap_Struct(cache_stats_class, 0, free, stats);
close:
  close(fd);
out:
  return result;
}

void Init_cache_stats()
{
  if(sizeof(int *) == 4)
  {
    max_mapping_pages = 131072; //512MiB
  }
  else
  {
    max_mapping_pages = UINT64_MAX;
  }

  page_size = sysconf(_SC_PAGESIZE);

  cache_stats_class = rb_define_class("CacheStats", rb_cObject);
  rb_define_method(cache_stats_class, "total_pages", cache_stats_total_pages, 0);
  rb_define_method(cache_stats_class, "cached_pages", cache_stats_cached_pages, 0);
  rb_define_method(cache_stats_class, "[]", cache_stats_index, 1);

  VALUE file_class = rb_const_get(rb_cObject, rb_intern("File"));
  rb_define_singleton_method(file_class,
                 "cache_stats",
                 file_cache_stats,
                 1);
}
