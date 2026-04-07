class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
       
     user ||= User.new # guest user (not logged in)
        alias_action :read, :update,  :to => :ru
        alias_action :read, :update, :create,  :to => :cru
        alias_action :read, :update, :create, :destroy,  :to => :crud
        alias_action :update, :destroy,  :to => :ud
        alias_action :read, :update, :destroy,  :to => :rud
        alias_action :read, :create, :to => :rc
        can :update, User do |us|
            us.id == user.id
            end
      if user.is_invited? 
        
      end        
      if user.is_client?          
         can :read, PriceList 
      end
      if user.is_seller? 
        can :ru, Modulo
        can :read, Item
        can :read, Branch
        can :manage, Transfer
        can :manage, TransferDetail
        can :cru, Client 
        can :manage, Sale
        can :manage , SaleDetail
        can :manage , Payment
        can :confirm_observed, Sale, user_id: user.id
        cannot :observe, Sale
        can :cru , Address
        can :crud , Province
        can :crud , Zona
        can :crud , Avenida
        can :crud , Country
        can :crud , Departamento
        can :crud , Contact
        can :read, PriceList
        can :read, ItemsSupplier
        can :manage, ClientPriceList
        can :read , Presentation
        can :manage, Stock
        can :manage, Price
        can :read, Account
        cannot :rud, Client do |cli|
            cli.asig_a_user_id != user.id
            end
        cannot :ud , Sale do |sale|
            sale.payments.count > 0 && !sale.observed?
            end    
        cannot :ud , Sale do |sale|
            sale.proformas.count > 0 && !sale.observed?
            end      
      end   
      if user.is_warehouser?
        can :ru, Modulo       
        cannot :manage , Sale
        can :ru, Item
        can :ru , Warehouse
        can :manage, Stock
        can :manage, Transfer
        can :manage, TransferDetail
        can :rc, Presentation
      end
      if user.is_manager?
        can :read, :all   
        can :manage, Branch
        can :cru, Supplier
        can :cru, PurchaseOrder
        can :manage, PurchaseOrderLine
        can :manage, Reception
        can :manage, Box do |box|
             box.box_users.first.user_id != user.id
        end
         cannot :rud, Client do |cli|
            cli.asig_a_user_id != user.id
            end
        cannot :ud , Sale do |sale|
            sale.payments.count > 0 && !sale.observed?
        end 
        can :observe, Sale
        can :confirm_observed, Sale

      end 
      if user.is_owner? 
         
      end
      if user.is_admin? 
            can :manage, :all   
      end
    #    elsif user.rol.permision == 5
    #      can :cru, :all
    #    elsif user.rol.permision == 4
    #    elsif user.rol.permision == 3
    #    elsif user.rol.permision == 2  
    #        can :read , Item
    #        can :create , Sale
    #        can :create , Client
    #        can :manage , SaleDetail
    #        can :manage , Stock
    #        can :ru , Modulo
    #        # can :cru , Client
    #        can :cru , Address
    #        can :crud , Departamento
    #        can :crud , Province
    #        can :crud , Zona
    #        can :crud , Avenida
    #        can :crud , Country
    #        can :crud , Contact
    #        can :create, Payment
    #        can :update, User
    #        can :read, Item
    #        # can :manage, Modulo
    #    elsif user.rol.permision = 1
    #     can :update, User
    #     can :read, Item
    #     cannot :manage , Sale
    #     cannot :manage , Client
    #   end
    # can :manage, Sale do |sal|
    #   sal.user == user
    #   can :manage, Payment
    # end
    # can :manage, Client do |cli|
    #   cli.asig_a_user_id == user.id
    # end





    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
