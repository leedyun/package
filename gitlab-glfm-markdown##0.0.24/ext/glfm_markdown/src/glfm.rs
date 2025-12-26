#[derive(Debug)]
pub struct RenderOptions {
    pub autolink: bool,
    // pub default_info_string: String,
    pub description_lists: bool,
    pub escape: bool,
    pub escaped_char_spans: bool,
    pub figure_with_caption: bool,
    pub footnotes: bool,
    // pub front_matter_delimiter: String,
    pub full_info_string: bool,
    pub gemojis: bool,
    pub gfm_quirks: bool,
    pub github_pre_lang: bool,
    pub greentext: bool,
    pub hardbreaks: bool,
    pub header_ids: Option<String>,
    pub ignore_empty_links: bool,
    pub ignore_setext: bool,
    pub math_code: bool,
    pub math_dollars: bool,
    pub multiline_block_quotes: bool,
    pub relaxed_autolinks: bool,
    pub relaxed_tasklist_character: bool,
    pub sourcepos: bool,
    pub experimental_inline_sourcepos: bool,
    pub smart: bool,
    pub spoiler: bool,
    pub strikethrough: bool,
    pub subscript: bool,
    pub superscript: bool,
    // pub syntax_highlighting: String,
    pub table: bool,
    pub tagfilter: bool,
    pub tasklist: bool,
    pub underline: bool,
    pub unsafe_: bool,
    pub wikilinks_title_after_pipe: bool,
    pub wikilinks_title_before_pipe: bool,

    pub debug: bool,
}

pub fn render(text: String, options: RenderOptions) -> String {
    render_comrak(text, options)
}

fn render_comrak(text: String, options: RenderOptions) -> String {
    let mut comrak_options = comrak::ComrakOptions::default();

    comrak_options.extension.autolink = options.autolink;
    comrak_options.extension.description_lists = options.description_lists;
    comrak_options.extension.footnotes = options.footnotes;
    // comrak_options.extension.front_matter_delimiter = options.front_matter_delimiter;
    comrak_options.extension.greentext = options.greentext;
    comrak_options.extension.header_ids = options.header_ids;
    comrak_options.extension.math_code = options.math_code;
    comrak_options.extension.math_dollars = options.math_dollars;
    comrak_options.extension.multiline_block_quotes = options.multiline_block_quotes;
    comrak_options.extension.shortcodes = options.gemojis;
    comrak_options.extension.spoiler = options.spoiler;
    comrak_options.extension.strikethrough = options.strikethrough;
    comrak_options.extension.subscript = options.subscript;
    comrak_options.extension.superscript = options.superscript;
    comrak_options.extension.table = options.table;
    comrak_options.extension.tagfilter = options.tagfilter;
    comrak_options.extension.tasklist = options.tasklist;
    comrak_options.extension.underline = options.underline;
    comrak_options.extension.wikilinks_title_after_pipe = options.wikilinks_title_after_pipe;
    comrak_options.extension.wikilinks_title_before_pipe = options.wikilinks_title_before_pipe;

    comrak_options.render.escape = options.escape;
    comrak_options.render.escaped_char_spans = options.escaped_char_spans;
    comrak_options.render.figure_with_caption = options.figure_with_caption;
    comrak_options.render.full_info_string = options.full_info_string;
    comrak_options.render.gfm_quirks = options.gfm_quirks;
    comrak_options.render.github_pre_lang = options.github_pre_lang;
    comrak_options.render.hardbreaks = options.hardbreaks;
    comrak_options.render.ignore_empty_links = options.ignore_empty_links;
    comrak_options.render.ignore_setext = options.ignore_setext;
    comrak_options.render.sourcepos = options.sourcepos;
    comrak_options.render.experimental_inline_sourcepos = options.experimental_inline_sourcepos;
    // comrak_options.render.syntax_highlighting = options.syntax_highlighting;

    comrak_options.render.unsafe_ = options.unsafe_;

    // comrak_options.parse.default_info_string = options.default_info_string;
    comrak_options.parse.relaxed_autolinks = options.relaxed_autolinks;
    comrak_options.parse.relaxed_tasklist_matching = options.relaxed_tasklist_character;
    comrak_options.parse.smart = options.smart;

    comrak::markdown_to_html(&text, &comrak_options)
}
