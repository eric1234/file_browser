class UploadedFile
  attr_reader :path, :public_path, :mime_type

  MIME_MAP = {
    'compressed'   => [/zip/, /tar/, /compress/],
    'contact'      => [/vcard/],
    'document'     => [/word/, /document/, /pdf/],
    'image'        => [/image/, /graphic/],
    'presentation' => [/powerpoint/, /presentation/],
    'spreadhseet'  => [/excel/, /spreadsheet/],
    'vector'       => [/svg/, /flash/],
    'video'        => [/video/],

    # Put XML towards the end as it might capture others
    'internet'     => [/html/, /xml/],

    # Put text VERY last as it might capture html
    'text'         => [/text/],
  }
  EXTENSION_MAP = {
    'compressed'   => %w(zip gz tar z tgz),
    'contact'      => %w(vcf),
    'document'     => %w(doc docx dot dotx odt pdf),
    'image'        => %w(odg png gif jpg jpeg tiff bmp),
    'internet'     => %w(html xml),
    'presentation' => %w(ppt pptx odp),
    'spreadsheet'  => %w(xls xlsx ods),
    'text'         => %w(txt text),
    'vector'       => %w(svg swf),
    'video'        => %w(flv mov avi mpeg mpg )
  }

  def initialize(path, mime_type='application/octet-stream', public_path=nil, &blk) # :nodoc:
    @path = path.to_s
    @mime_type = mime_type
    @public_path = public_path
    @retrieve = blk
  end

  def general_type
    MIME_MAP.each do |gt, types|
      return gt if types.any? {|t| t =~ mime_type}
    end
    EXTENSION_MAP.each do |gt, extensions|
      return gt if extensions.any? {|e| e == extension}
    end
    return 'unknown'
  end

  def extension
    return unless path =~ /\./
    path.split('.').last.downcase
  end

  def to_s
    File.basename path.to_s
  end

  # Will return a stream that can be used to read the resource
  def stream
    @retrieve.call
  end
end
