require "rails/generators"

class ResourcesController < ApplicationController

  def new
    Rails.logger.debug "Rendering the new template"
    respond_to do |format|
      format.html { render "new" }
      format.json { render json: { message: "JSON response" } }
    end
  end

  def create
    resource_name = params[:resource_name].underscore
    fields = params[:fields].map { |field| "#{field[:name]}:#{field[:type]}" }

    begin
      Rails::Generators.invoke("crud_resource", [ resource_name, *fields ])
      result = ActiveRecord::MigrationContext.new("db/migrate").migrate

      if result
        flash[:notice] = "Resource '#{resource_name}' created and migrations ran successfully!"
      else
        raise "Migration failed. Please check the migration file for '#{resource_name}'."
      end

      swagger_result = system("rake rswag:specs:swaggerize")

      if swagger_result
        flash[:notice] += " Swagger docs generated successfully!"
      else
        raise "Failed to generate Swagger docs."
      end

    rescue => e
      # Log the error and display it as a flash message
      Rails.logger.error "Error creating resource '#{resource_name}': #{e.message}"
      flash[:alert] = "Failed to create resource: #{e.message}"
    end

    # Redirect to the new resource page
    redirect_to new_resource_path
  end
end
