# -*- encoding: utf-8 -*-

require "cgi"

require "acme/smileage/blog/entry"
require "acme/smileage/utils/base_downloader"

module Acme
  class Smileage
    module Blog
      class AmebloDownloader < Acme::Smileage::Utils::BaseDownloader
        def get_entry_list(blog, blog_link, page=1)
          unless blog_link
            Acme::Smileage::Blog::Entry::List.new
          end

          with_nokogiri(blog_link, "entrylist-#{page}.html") do |doc, uri|
            Acme::Smileage::Blog::Entry::List.new {|e|
              e.link = uri.to_s
              e.entries = parse_entry_list(blog, doc)
              e.next_page = parse_next_page(doc)
            }
          end
        end

        def get_entry_body(entry_link)
          with_nokogiri(entry_link) do |doc|
            Acme::Smileage::Blog::Entry::Body.new {|e|
              e.text = parse_text(doc, ".articleText")
              e.comment_link = parse_attr(doc, ".commentLink", :href)
              e.next_entry_link = parse_attr(doc, ".pagingNext", :href)
              e.prev_entry_link = parse_attr(doc, ".pagingPrev", :href)
              e.image_links = parse_image_list(doc)
              e.comments = parse_comment_list(entry_link, doc)
            }
          end
        end

        private

        def parse_entry_list(blog, doc)
          doc.css(".contentsList li").map {|li|
            Acme::Smileage::Blog::Entry::Header.new(blog) {|e|
              e.link = parse_attr(li, ".contentTitle", :href)
              e.title = parse_text(li, ".contentTitle")
              e.datetime = parse_text(li, ".contentTime")
              e.comment_count = parse_number(li, ".contentComment")
              e.good_count = parse_number(li, "a.skinWeakColor")
              e.author = guess_author(e.link, e.title)

              e.define_singleton_method(:get_body, Proc.new {
                blog.get_entry_body(e)
              })
            }
          }
        end

        def parse_next_page(doc)
          parse_attr(doc, ".listPagePaging .pagingNext", :href) {|href|
            href[/entrylist-(\d+)/, 1].to_i if href
          }
        end

        def parse_image_list(doc)
          doc.css(".articleText a img").map{|e|
            src =  e[:src]
            if src.sub!(/t[0-9]+_([0-9]+)/) { "o#{$1}" }
              src
            end
          }.compact
        end

        def parse_comment_list(entry_link, doc)
          doc.css(".commentList li").map {|li|
            Acme::Smileage::Blog::Entry::Comment.new {|e|
              e.link = "%s#%s" % [entry_link, li.css("a")[0][:id]]
              e.title = parse_text(li, ".commentHeader")
              e.text = parse_text(li, ".commentBody")
              e.author = parse_text(li, ".commentAuthor")
              e.author_link = parse_attr(li, ".commentAuthor", :href)
              e.datetime = parse_text(li, ".commentTime > time")
            }
          }
        end


        BLOG_ENTRY_AUTHOR_MAPPING = {
          "http://ameblo.jp/smileage-submember/entry-11018609295.html" => "Katsuta",
          "http://ameblo.jp/smileage-submember/entry-11039125372.html" => "Nakanishi",
          "http://ameblo.jp/smileage-submember/entry-11063872434.html" => "Katsuta",
          "http://ameblo.jp/smileage-submember/entry-11073466463.html" => "Tamura",
          "http://ameblo.jp/smileage-submember/entry-11155617406.html" => nil, # スタッフ
          "http://ameblo.jp/smileage-submember/entry-11215252589.html" => "Tamura",
          "http://ameblo.jp/smileage-submember/entry-11217726959.html" => "Takeuchi",
          "http://ameblo.jp/smileage-submember/entry-11453335643.html" => "Tamura",
          "http://ameblo.jp/smileage-submember/entry-11529821236.html" => "Tamura",
          "http://ameblo.jp/smileage-submember/entry-11545517618.html" => "Takeuchi",
          "http://ameblo.jp/smileage-submember/entry-11545630723.html" => "Takeuchi",
          "http://ameblo.jp/smileage-submember/entry-11614497735.html" => nil, # スタッフ
          "http://ameblo.jp/smileage-submember/entry-11623987909.html" => "Takeuchi",
          "http://ameblo.jp/smileage-submember/entry-11821080105.html" => "Nakanishi"
        }

        def guess_author(link, title)
          if author = BLOG_ENTRY_AUTHOR_MAPPING[link]
            return author
          end

          case link
          when /wadaayaka/
            "Wada"
          when /kanon-fukuda/
            "Fukuda"
          when /smileage-submember/
            case title
            when /中西香菜/, /中西/
              "Nakanishi"
            when /竹内朱莉/, /竹内/, /朱莉/
              "Takeuchi"
            when /勝田里奈/, /R.?I.?N.?A/i
              "Katsuta"
            when /田村芽実/, /田村/, /芽実/
              "Tamura"
            end
          end
        end

        def parse_text(doc, css)
          e = doc.css(css)
          return nil if not e

          # これだと改行がうまく変換できない場合があるので自前で処理
          # e.css("br").each {|ee| ee.replace("\n") }
          # e.text.strip

          v = e.to_s
          v.gsub!(/<br\/?>/i, "\n")
          v.gsub!(%r{<img.*?src="(http://stat\.ameba\.jp/user_images/.*?/)t[0-9]+_([0-9]+\.jpg)".*?>}) { "%so%s" % [$1, $2] }
          v.gsub!(/<.*?>/, "")
          v.gsub!(/\r/, "")
          v.gsub!(/\u00a0/, "")
          CGI.unescapeHTML(v.strip) if v
        end

        def parse_number(doc, css)
          v = parse_text(doc, css)
          return nil if not v

          vv = v[/\d+/, 0]
          return nil if not vv

          vv.to_i
        end

        def parse_attr(doc, css, attr)
          e = doc.css(css)
          return nil if not e or e.empty?

          v = e[0][attr]
          v.strip! if v

          if block_given?
            yield v
          else
            v
          end
        end
      end
    end
  end
end
