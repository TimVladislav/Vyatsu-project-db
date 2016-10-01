class StudentsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "229250"

  def index
   @students = Student.all
  end
  def show
    @student = Student.find(params[:id])
    # Info VK app
    @client_id = "5644198"
    @scope = "offline,messages"
    # VK app send messages
    @params = "user_id=" + @student.sn + "&message=Уважаемый(ая) " + @student.fio + "<br>Дата сдачи вашей курсовой работы: " + @student.date_work.to_s + "<br><br>Преподаватель: " + @student.teacher + "<br><br>С уважением, ВятГУ"
    @token = "access_token=e36467abf784acf6fc31d94f142a7052efaaa0ecb5c107bad5b37ada0c17faa7985367a752325fa5c0134"
    @method = "messages.send"
  end
  def new
    @student = Student.new 
  end
  def edit
    @student = Student.find(params[:id])
  end
  def upload
    
  end
  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to @student
    else
      render 'edit'
    end
  end
  def update
    @student = Student.find(params[:id])

    if @student.update(student_params)
      redirect_to @student
    else
      render 'edit'
    end
  end
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    redirect_to students_path
  end

  private
    def student_params
      params.require(:student).permit(:fio, :group, :date_work, :subject, :teacher, :email, :sn, :tnumber)
    end
end
