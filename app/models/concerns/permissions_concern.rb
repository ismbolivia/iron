module PermissionsConcern extend ActiveSupport::Concern
	def is_invited?
		self.rol.permision == 0
	end
	def is_client?
		self.rol.permision == 1
	end	
	def is_warehouser?
		self.rol.permision == 2
	end
	def is_seller?
		self.rol.permision >= 3
	end
	
	def is_manager?
		self.rol.permision >= 4
	end
	def is_owner?
		self.rol.permision >= 5
	end
	def is_admin?
		self.rol.permision >= 6
	end
end