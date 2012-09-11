# SundySilence

Publish static HTML site that is auto-linked to other pages with page title from Markdown files.

## Installation

Install it yourself as:

    $ gem install sundysilence

## Usage

Create config.yml.

    input_dir: inputs
    output_dir: published
    template_dir: templates
    stylesheet_dir: stylesheets
    
    pre_content: pre_content.html
    post_content: post_content.html
    
    site_title: "The Static Wiki"
    expect_title: index
    listpage_title: "All Pages"
    
    combination_page_file: all

All entries are put in "input_dir" setting that are written in Markdown.
"template_dir" setting includes "pre_content" setting file and "post_content" setting file.
All entries that are replaced *.md with *.html are published to "ouput_dir" setting.

Write entries.
This example file is named "the_page.md".

    The Page
    
    # The Page Title
    
    Body text.
    
    Some sentences.

The first line is the page title.
If a entry contains the title string,
that string is linked to this entry.
This title string is join the "site_title" setting setting above: "The Page - The Static Wiki".
The file is set "expect_title" setting is not joined the "title" setting.
{{ title }} is replaced with that is joined string or not joined string
in "pre_content" setting, "post_content" setting and all entries.
This sample is published to "the_page.html".

"list.html" that lists name of pages is automatically created.
The title of it is "listpage_title" setting.

"all.html" that lists all pages are contains if "combination_page_title" setting is set.
Carefully, sometimes this page is very long.

Finally, run SundySilence when these files above are ready.

    $ sundysilence

Just do it.

