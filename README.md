# SundySilence

publish HTML site from Markdown files.

## Installation

Add this line to your application's Gemfile:

    gem 'sundysilence'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sundysilence

## Usage

Create config.yml.

    input_dir: inputs
    output_dir: published
    template_dir: templates
    stylesheet_dir: stylesheets
    
    pre_content: pre_content.html
    post_content: post_content.html
    
    title: "The Static Wiki"
    expect_title: index
    listpage_title: "All Pages"
    
    combination_page_file: all

All entries are put in "input_dir" that are written in Markdown.
"template_dir" includes "pre_content" file and "post_content" file.
All entries that are replaced *.md with *.html are published to "ouput_dir".

Write entries.
This example file is named "the_page.md".

    The Page
    
    # The Page Title
    
    Body text.
    
    Some sentences.

The first line is the page title.
If a entry contains the title string,
that string is linked to this entry.
This title string is join the "title" setting above: "The Page - The Static Wiki".
The file is set "expect_title" setting is not joined the "title" setting.
{{ title }} is replaced with that is joined string or not joined string
in "pre_content", "post_content" and all entries.

Run SundySilence when these files are ready.

    $ sundysilence

Just do it.

