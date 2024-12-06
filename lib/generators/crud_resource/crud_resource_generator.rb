class CrudResourceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :fields, type: :array, default: [], banner: "field:type field:type"

  def generate_model
    generate("model", "#{file_name} #{fields.join(' ')}")
  end

  def generate_controller
    template "controller.rb.erb", "app/controllers/#{file_name.pluralize}_controller.rb"
  end

  def generate_routes
    route "resources :#{file_name.pluralize}"
  end

  def generate_serializer
    create_file "app/serializers/#{file_name}_serializer.rb", <<~SERIALIZER
      class #{file_name.camelize}Serializer < ActiveModel::Serializer
        attributes #{fields.map { |f| ":#{f.split(':').first}" }.join(', ')}
      end
    SERIALIZER
  end

  def add_swagger_documentation
    create_file "spec/integration/#{file_name.pluralize}_spec.rb", <<~SWAGGER
      require 'swagger_helper'

      RSpec.describe '#{file_name.camelize.pluralize} API', type: :request do
        # GET /#{file_name.pluralize}
        path '/#{file_name.pluralize}' do
          get 'Retrieve all #{file_name.pluralize}' do
            produces 'application/json'
            response '200', 'successful request' do
              run_test!
            end
          end

          post 'Create a new #{file_name.camelize}' do
            consumes 'application/json'
            parameter name: :#{file_name.singularize}, in: :body, schema: {
              type: :object,
              properties: {
                #{fields.map { |field| "#{field.split(':').first}: { type: :string }" }.join(",\n                ")}
              },
              required: [#{fields.select { |field| field.split(":").last == "string" }.map { |field| "'#{field.split(":").first}'" }.join(", ")}]
            }

            response '201', '#{file_name.camelize} created successfully' do
              let(:#{file_name.singularize}) { { #{fields.map { |f| "#{f.split(':').first}: 'Test #{f.split(':').first.capitalize}'" }.join(", ")} } }
              run_test!
            end
          end
        end

        # GET /#{file_name.pluralize}/{id}
        path '/#{file_name.pluralize}/{id}' do
          get 'Retrieve a #{file_name.camelize} by ID' do
            produces 'application/json'
            parameter name: :id, in: :path, type: :string

            response '200', '#{file_name.camelize} found' do
              let(:id) { #{file_name.camelize}.create(#{fields.map { |f| "#{f.split(':').first}: 'Sample'" }.join(", ")}).id }
              run_test!
            end

            response '404', '#{file_name.camelize} not found' do
              let(:id) { 'nonexistent' }
              run_test!
            end
          end

          patch 'Partially update a #{file_name.camelize}' do
            consumes 'application/json'
            parameter name: :id, in: :path, type: :string
            parameter name: :#{file_name.singularize}, in: :body, schema: {
              type: :object,
              properties: {
                #{fields.map { |field| "#{field.split(':').first}: { type: :string }" }.join(",\n                ")}
              }
            }

            response '200', '#{file_name.camelize} updated successfully' do
              let(:id) { #{file_name.camelize}.create(#{fields.map { |f| "#{f.split(':').first}: 'Sample'" }.join(", ")}).id }
              let(:#{file_name.singularize}) { { #{fields.map { |f| "#{f.split(':').first}: 'Updated'" }.join(", ")} } }
              run_test!
            end

            response '404', '#{file_name.camelize} not found' do
              let(:id) { 'nonexistent' }
              let(:#{file_name.singularize}) { { #{fields.map { |f| "#{f.split(':').first}: 'Updated'" }.join(", ")} } }
              run_test!
            end
          end

          put 'Fully update a #{file_name.camelize}' do
            consumes 'application/json'
            parameter name: :id, in: :path, type: :string
            parameter name: :#{file_name.singularize}, in: :body, schema: {
              type: :object,
              properties: {
                #{fields.map { |field| "#{field.split(':').first}: { type: :string }" }.join(",\n                ")}
              },
              required: [#{fields.select { |field| field.split(":").last == "string" }.map { |field| "'#{field.split(":").first}'" }.join(", ")}]
            }

            response '200', '#{file_name.camelize} fully updated' do
              let(:id) { #{file_name.camelize}.create(#{fields.map { |f| "#{f.split(':').first}: 'Sample'" }.join(", ")}).id }
              let(:#{file_name.singularize}) { { #{fields.map { |f| "#{f.split(':').first}: 'Updated Fully'" }.join(", ")} } }
              run_test!
            end

            response '404', '#{file_name.camelize} not found' do
              let(:id) { 'nonexistent' }
              let(:#{file_name.singularize}) { { #{fields.map { |f| "#{f.split(':').first}: 'Updated Fully'" }.join(", ")} } }
              run_test!
            end
          end

          delete 'Delete a #{file_name.camelize}' do
            parameter name: :id, in: :path, type: :string

            response '204', '#{file_name.camelize} deleted successfully' do
              let(:id) { #{file_name.camelize}.create(#{fields.map { |f| "#{f.split(':').first}: 'Sample'" }.join(", ")}).id }
              run_test!
            end

            response '404', '#{file_name.camelize} not found' do
              let(:id) { 'nonexistent' }
              run_test!
            end
          end
        end
      end
    SWAGGER
  end
end
