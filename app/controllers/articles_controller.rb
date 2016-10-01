class ArticlesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "229250", except: [:show]
  def index
    @articles = Article.all
  end
  def show
    @article = Article.find(params[:id])
    @paht = 'public/uploads/article/linktowork/' + @article.id.to_s + '/' + @article.linktowork.to_s[@article.linktowork.to_s.rindex("/")+1..-1]
    @ext = @article.linktowork.to_s[@article.linktowork.to_s.rindex(".")..-1] 
    case @ext
    when ".docx"
      require 'docx'
      @doc = Docx::Document.open(@paht).to_html
    when ".txt"
      @doc = File.open(@paht){|file| file.read}
    when ".pdf"
      @i = 1
      @pdf = PDF::Reader.new(@paht)
      @pdf.pages.each do |page|
        @doc = @doc.to_s + @pdf.page(@i).to_s
        @i = @i + 1
      end
    when ".rtf"
      require 'yomu'
      @yomu = Yomu.new(@paht).text
      @doc = @yomu.to_s
    end
  end
  def new
    @article = Article.new
  end
  def edit
    @article = Article.find(params[:id])
  end
  def upload 
    uploaded_io = params[:linktowork]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end
  def create
    @article = Article.new(article_params)
    if @article.save
      create_txt
      create_docx
      create_pdf
      create_rtf
      VyatsuMailer.welcome_email(@article).deliver
      redirect_to @article
    else
      render 'new'
    end
  end
  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      create_txt
      create_docx
      create_pdf
      create_rtf
      redirect_to @article
    else
      render 'edit'
    end
  end
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end
  private
    def article_params
      params.require(:article).permit(:fio, :group, :tnumber, :email, :sn, :typework, :year, :teacher, :workname, :mark, :linktowork, :student_id)
    end
    def create_txt
      require 'docx'
      @ext = @article.linktowork.to_s[@article.linktowork.to_s.rindex(".")..-1] 
      @paht = 'public/uploads/article/linktowork/' + @article.id.to_s + '/' + @article.linktowork.to_s[@article.linktowork.to_s.rindex("/")..-5]

      case @ext
      when ".docx"
        @paht = 'public/uploads/article/linktowork/' + @article.id.to_s + '/' + @article.linktowork.to_s[@article.linktowork.to_s.rindex("/")..-6]
        File.open(@paht + '.txt', "w+") do |f|
          f.write(Docx::Document.open(@paht + '.docx').to_s)
        end
      when ".pdf"
       @paht = 'public/uploads/article/linktowork/' + @article.id.to_s + '/' + @article.linktowork.to_s[@article.linktowork.to_s.rindex("/")..-5]
        @i = 1
        @pdftxt = ''
        @pdf = PDF::Reader.new(@paht + '.pdf')
        @pdf.pages.each do |page|
          @pdftxt = @pdftxt.to_s + @pdf.page(@i).to_s
          #@doc = @doc.to_s + @pdf.page(@i).to_s
          @i = @i + 1
        end

        File.open(@paht + '.txt', "w+") do |f|
          f.write(@pdftxt)
        end
      when ".rtf"
        require 'yomu'
        @yomu = Yomu.new(@paht + '.rtf').text
        File.open(@paht + '.txt', "w+") do |f|
          f.write(@yomu.to_s)
        end
      end
    end
    
    def create_docx
      require 'docx'
      @ext = @article.linktowork.to_s[@article.linktowork.to_s.rindex(".")..-1] 
      @paht = 'public/uploads/article/linktowork/' + @article.id.to_s + '/' + @article.linktowork.to_s[@article.linktowork.to_s.rindex("/") + 1..-5]


     case @ext
     when ".txt"
       @txt = File.open(@paht + '.txt'){|file| file.read}
       Caracal::Document.save(@paht + '.docx') do |docx|
         docx.p @txt.to_s
       end
     when ".pdf"
       @i = 1;
       @pdf = PDF::Reader.new(@paht + '.pdf')
       @pdf.pages.each do |page|
         @doc = @doc.to_s + @pdf.page(@i).to_s
         #@doc = @doc.to_s + @pdf.page(@i).to_s
         @i = @i + 1
       end
       Caracal::Document.save(@paht + '.docx') do |docx|
         docx.p @doc
       end
     when ".rtf"
       require 'rtf'
       @yomu = Yomu.new(@paht + '.rtf').text
       Caracal::Document.save(@paht + '.docx') do |docx|
         docx.p @yomu.to_s
       end
     end

    def create_pdf
      require 'docx'
      require 'prawn'
      @ext = @article.linktowork.to_s[@article.linktowork.to_s.rindex(".")..-1] 
      @paht = 'public/uploads/article/linktowork/' + @article.id.to_s + '/' + @article.linktowork.to_s[@article.linktowork.to_s.rindex("/") + 1..-5]


      case @ext
      when ".docx"
        @docx = Docx::Document.open(@paht + 'docx').to_s
        Prawn::Document.generate(@paht + 'pdf') do |pdf|
          pdf.font_families.update("Arial" => {
            :normal => Rails.root.join('public/fonts', 'Arial.ttf'),
            :italic => Rails.root.join('public/fonts', 'Arial Italic.ttf')
          })
          pdf.font "Arial"
          pdf.text @docx.to_s
        end
      when ".txt"
        @txt = File.open(@paht + '.txt'){|file| file.read}
        Prawn::Document.generate(@paht + '.pdf') do |pdf|
          pdf.text @txt.to_s
        end
      when ".rtf"
        require 'yomu'
        @yomu = Yomu.new(@paht + '.rtf').text
        Prawn::Document.generate(@paht + '.pdf') do |pdf|
          pdf.text @yomu.to_s
        end
      end
    end

    def create_rtf
      require 'rtf'
      @ext = @article.linktowork.to_s[@article.linktowork.to_s.rindex(".")..-1]
      @paht = 'public/uploads/article/linktowork/' + @article.id.to_s + '/' + @article.linktowork.to_s[@article.linktowork.to_s.rindex("/") + 1..-5]
      @rtf = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))

      case @ext
      when ".docx"
        @docx = Docx::Document.open(@paht + 'docx').to_s
        @rtf.paragraph << @docx
        File.open(@paht + 'rtf', "w") {|file| file.write(@rtf.to_rtf)}
      when ".txt"
        @txt = File.open(@paht + '.txt'){|file| file.read}
        @rtf.paragraph << @txt.to_s
        File.open(@paht + '.rtf', "w"){|file| file.write(@rtf.to_rtf)}
      when ".pdf"
        @i = 1;
        @pdf = PDF::Reader.new(@paht + '.pdf')
        @pdf.pages.each do |page|
          @doc = @doc.to_s + @pdf.page(@i).to_s
          @i = @i + 1
        end
        @rtf.paragraph << @doc.to_s
        File.open(@paht + '.rtf', "w"){|file| file.write(@rtf.to_rtf)}
      end
    end
  end
end
