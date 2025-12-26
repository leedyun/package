class PublisherSupport
  def before src_dir
    FileUtils.touch (File.join src_dir, 'file1.mmd')
  end
  def after dirs
    img_lin = File.join('images','linux.jpeg')
    files_to_delete = [ img_lin ,'images', 'file4.html', 'ajax-loader.gif', 'help.png', 'search.html' ]
    dirs.each do |dir|
      files_to_delete.each do |file| 
        delf = File.join dir,file
        FileUtils.rm_rf delf
      end
    end
  end
end

