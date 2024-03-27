require 'tools/log'

class FileManager

    LOG_COMP = 'FM'

    # Global relative PATHS
    DEPLOYMENT  = '../../deployments'
    TERRAFORM   = '../terraform'

    # Temporarily changes the current directory to `dir`, executes the block, and reverts the directory back.
    def self.change_dir_temp(dir)
        begin
            pwd = Dir.pwd
            Dir.chdir dir
            yield
        ensure
            Dir.chdir pwd
        end
    end
end