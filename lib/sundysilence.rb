# encoding: utf-8

require 'fileutils'
require 'cgi'
require 'yaml'
require 'redcarpet'
require 'tx'
require 'liquid'

INDEX_FILE = "tmp.index"

module SundySilence
  class Builder
    def initialize
      @config = YAML::load(open('./config.yml'))
      @markdown = Redcarpet::Markdown.new(Redcarpet::Render::XHTML.new(:hard_wrap => true), :fenced_code_blocks => true, :autolink => true, :superscript => true)
      @entries = Hash.new
  
      if not Dir.exist?(@config['input_dir'])
        puts "#{@config['input_dir']} is not found\n"
        exit -1
      end
  
      Dir.foreach(@config['input_dir']) do |filename|
        if filename =~ /^\.+$/
          next
        end
  
        if filename =~ /^.*\.md$/ or filename =~ /^.*\.markdown$/
          open(File.join(@config['input_dir'], filename)) do |fd|
            title = fd.gets.chomp
            @entries[title] = filename
          end
        end
      end
  
      tx = Tx::Builder.new
      tx.add_all(@entries.keys)
      tx.build(INDEX_FILE)
      @index = Tx::Index.open(INDEX_FILE)
  
      FileUtils.rm_r(@config['output_dir']) if Dir.exist?(@config['output_dir'])
      Dir.mkdir(@config['output_dir'])
  
      @pre_content = nil
      open(File.join(@config['template_dir'], @config['pre_content']), 'rb') do |fd|
        @pre_content = fd.read
      end
  
      @post_content = nil
      open(File.join(@config['template_dir'], @config['post_content']), 'rb') do |fd|
        @post_content = fd.read
      end
  
      if not @config['combination_page_file'].nil?
        @combination = ""
      end
    end
  
    def link_to_entries(text)
      @index.gsub(text) do |s, i|
        link_to = @entries[s].gsub(/(.*)\.(md|markdown)$/, '\1.html')
        "<a href=\"./#{CGI.escape(link_to)}\">#{CGI.escape_html(s)}</a>"
      end
    end
  
    def render_template(text, title)
      liquid = Liquid::Template.parse(text)
      liquid.render({'title' => title})
    end
  
    def build_a_entry(body, title)
      urls = Array.new
      body.gsub!(/((http|https):\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?)/) do |matched|
        url = matched
        breaks = ""
        if url =~ /^(.*)([\r\n]+)$/
          url = $1
          breaks = $2
        end
        urls << url
        "{{#{urls.size - 1}}}" + breaks
      end
      body = link_to_entries(body)
      (0..urls.size - 1).each do |i|
        body.sub!(/\{\{#{i.to_s}\}\}/, urls[i].to_s)
      end if urls.size > 0
      body = @markdown.render(body)
      if not @config['combination_page_file'].nil?
        @combination += body
      end
      page = @pre_content + body + @post_content
      page = render_template(page, title)
    end
  
    def build_entries
      @entries.each do |page_title, filename|
        output_filename = nil
        open(File.join(@config['input_dir'], filename), 'rb') do |fd|
          fd.gets
          body = fd.read
          if not filename =~ /#{@config['expect_title']}\.(md|markdown)/
            title = page_title + " - " + @config['title']
          else
            title = page_title
          end
          page = build_a_entry(body, title)
          output_filename = filename.gsub(/(.*)\.(md|markdown)$/, '\1.html')
          open(File.join(@config['output_dir'], output_filename), 'w') do |output_fd|
            output_fd.puts page
          end
        end
      end
    end

    def build_pages
      build_entries
      build_list_page
      if not @config['combination_page_file'].nil?
        build_combination_page
      end
      FileUtils.cp_r(@config['stylesheet_dir'], @config['output_dir'])
    end
  
    def build_combination_page
      open(File.join(@config['output_dir'], @config['combination_page_file'] + '.html'), 'w') do |fd|
        title = 'all - ' + @config['title']
        page = @pre_content + @combination + @post_content
        page = render_template(page, title)
        fd.puts page
      end
    end
  
    def build_list_page
      open(File.join(@config['output_dir'], 'list.html'), 'w') do |fd|
        title = @config['listpage_title'] + ' - ' + @config['title']
        body = "\# #{title}\n\n"
        list_text = ""
        @entries.each do |title, filename|
          list_text += "* #{title}\n"
        end
        body += list_text
        body = link_to_entries(body)
        body = @markdown.render(body)
        page = @pre_content + body + @post_content
        page = render_template(page, title)
        fd.puts page
      end
    end
  
    def cleanup
      File.unlink(INDEX_FILE)
    end
  end
end

