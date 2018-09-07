# Admin::UsersController.class_eval do
#
#   def create
#   end
#
#   def update
#   end
#
#   private
#
#   def user_params
#     params.require(:user).permit(
#       :name, :email, :phone, :dni,
#       reservation_attributes: [:id, :origin, :arrival]
#     )
#   end
#
# end
