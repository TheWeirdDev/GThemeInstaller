require 'uri'
#TODO: Support github links
class UrlParser

    def initialize url
        begin
            @uri1 = URI::parse(URI::unescape url)
            @params = URI.decode_www_form(@uri1.query)
            @dl_url = @uri1.query[4..-4]
            @uri2 = URI::parse(@dl_url)
        rescue
            puts "ERROR: Invalid URL"
            exit 1
        end
    end

    def get_file_name
        @params[1][1]
    end

    def get_file_type
        # TODO: Add more file types
        types = {'application/x-xz'  => :txz,
                 'application/zip'    => :zip,
                 'application/x-gzip' => :tgz}

        if types.include? @params[2][1]
            return types[@params[2][1]]
        elsif get_file_name.include? 'tar.xz'
            return :txz
        elsif get_file_name.include? '.zip'
            return :zip
        elsif get_file_name.include? '.tar.gz'
            return :tgz
    end

    def get_download_url
        @dl_url
    end

    def get_size
        suffixes = ['B', 'KB' , 'MB' , 'GB' , 'TB']
        s = Integer(@params[3][1])
        i = 0
        while s > 1024
            s /= 1024.0
            i+=1
        end
        "#{s.round(2)} #{suffixes[i]}"
    end

    def get_type
        types = {'gtk3_themes'   => 'Gtk3 Theme',
                 'icons'         => 'Icon Theme',
                 'cursors'       => 'Cursor',
                 'gtk2_themes'   => 'Gtk2 Theme'}
        types[@params[5][1]]
    end

    def get_category
        if @params[5][1].include? 'theme'
            return "themes"
        else
            return "icons"
        end
    end
end





