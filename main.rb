require "gtk3"
require_relative 'zip_extract'

class MainWindow < Gtk::Window

    def initialize (url)
        super

        set_title "GthemeInstaller"
        signal_connect "destroy" do
            Gtk.main_quit
        end

        vbox = Gtk::Box.new(:vertical , 10)

        @label_name = Gtk::Label.new()
        @label_type = Gtk::Label.new()
        @label_size = Gtk::Label.new()

        @label_type.set_markup "<b>Type:</b>"
        @label_name.set_markup "<b>Name:</b>"
        @label_size.set_markup "<b>Size:</b>"
        @label_type.xalign = 0
        @label_name.xalign = 0
        @label_size.xalign = 0

        hbox = Gtk::Box.new(:horizontal , 10)
        @install_btn = Gtk::Button.new(:label => "Install")
        @install_btn.signal_connect "clicked" do |_widget|

        end
        @install_btn.hexpand = true

        @enable_btn = Gtk::Button.new(:label => "Enable")
        @enable_btn.signal_connect "clicked" do |_widget|

        end
        @enable_btn.sensitive = false
        @enable_btn.hexpand = true


        @progress = Gtk::ProgressBar.new()
        @progress.fraction = 0


        vbox.add @label_name
        vbox.add @label_type
        vbox.add @label_size
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


window = MainWindow.new 'aa'
window.show_all
window.present
Gtk.main
