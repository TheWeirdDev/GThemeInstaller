#!/usr/bin/env ruby

# Author: Alireza S.N
# LICENSE: GPL3+

if ARGV.length < 1
    puts 'Error: URL is required'
    exit 1
end

require 'gtk3'
require 'fileutils'
require 'open-uri'
require_relative 'archive'
require_relative 'url_parser'

class MainWindow < Gtk::Window

    def initialize url
        super

        @parser = UrlParser.new url

        set_title "GthemeInstaller"
        signal_connect "destroy" do
            Gtk.main_quit
        end

        vbox = Gtk::Box.new(:vertical , 10)

        @label_name = Gtk::Label.new()
        @label_type = Gtk::Label.new()
        @label_size = Gtk::Label.new()
        @label_stat = Gtk::Label.new()

        @name = @parser.get_file_name.gsub(/\.(tar\...|zip)/, '')
        @label_name.set_markup "<b>Name:</b> #{@name}"
        @label_type.set_markup "<b>Type:</b> #{@parser.get_type}"
        @label_size.set_markup "<b>Size:</b> #{@parser.get_size}"
        @label_type.xalign = 0
        @label_name.xalign = 0
        @label_size.xalign = 0

        hbox = Gtk::Box.new(:horizontal , 10)
        @install_btn = Gtk::Button.new(:label => "Install")
        @install_btn.signal_connect "clicked" do |_widget|
            @progress.fraction = 0
            @label_stat.text = 'Downloading'

            @dest = ""
            thraed = Thread.new {
                begin
                    dest = "#{Dir.home}/.cache/gthemeinstaller"
                    FileUtils.mkdir_p dest
                    dl = open(@parser.get_download_url)
                    dest = "#{dest}/#{dl.base_uri.to_s.split('/')[-1]}"
                    @dest = dest
                    @install_btn.sensitive = false
                    IO.copy_stream(dl, dest)
                    @progress.fraction = 0.5
                    @label_stat.text = 'Installing'
                rescue
                    @install_btn.sensitive = true
                end
            }
            thraed.join

            type = @parser.get_file_type
            case type
                when :zip
                    `unzip -o #{@dest} -d ~/.#{@parser.get_category}/`
                    puts 'zip'
                when :txz
                    `tar -xf #{@dest} -C ~/.#{@parser.get_category}/`
                    puts 'tar.xz'
                else
                    puts "Unknown file"
            end
            @label_stat.text = 'Done'
            @progress.fraction = 1
            @enable_btn.sensitive = true
        end
        @install_btn.hexpand = true

        @enable_btn = Gtk::Button.new(:label => "Enable")
        @enable_btn.signal_connect "clicked" do |_widget|
            if @parser.get_type.include? "Gtk"
                `gsettings set 'org.gnome.desktop.interface' gtk-theme #{@name}`
            elsif @parser.get_type == "Cursor"
               `gsettings set 'org.gnome.desktop.interface' cursor-theme #{@name}`
            else
                `gsettings set 'org.gnome.desktop.interface' icon-theme #{@name}`
            end
        end

        @enable_btn.sensitive = false
        @enable_btn.hexpand = true


        @progress = Gtk::ProgressBar.new()

        vbox.add @label_name
        vbox.add @label_type
        vbox.add @label_size
        vbox.add @label_stat
        vbox.add @progress

        hbox.add @install_btn
        hbox.add @enable_btn
        vbox.add hbox

        add vbox

        set_default_size 500, -1
        set_border_width 10
        set_window_position Gtk::WindowPosition::CENTER
    end

end

window = MainWindow.new ARGV[0]
window.show_all
window.present
Gtk.main
