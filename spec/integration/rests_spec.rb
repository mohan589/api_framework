require 'swagger_helper'

RSpec.describe 'Rests API', type: :request do
  # GET /rests
  path '/rests' do
    get 'Retrieve all rests' do
      produces 'application/json'
      response '200', 'successful request' do
        run_test!
      end
    end

    post 'Create a new Rest' do
      consumes 'application/json'
      parameter name: :rest, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '201', 'Rest created successfully' do
        let(:rest) { { name: 'Test Name' } }
        run_test!
      end
    end
  end

  # GET /rests/{id}
  path '/rests/{id}' do
    get 'Retrieve a Rest by ID' do
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Rest found' do
        let(:id) { Rest.create(name: 'Sample').id }
        run_test!
      end

      response '404', 'Rest not found' do
        let(:id) { 'nonexistent' }
        run_test!
      end
    end

    patch 'Partially update a Rest' do
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :rest, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      response '200', 'Rest updated successfully' do
        let(:id) { Rest.create(name: 'Sample').id }
        let(:rest) { { name: 'Updated' } }
        run_test!
      end

      response '404', 'Rest not found' do
        let(:id) { 'nonexistent' }
        let(:rest) { { name: 'Updated' } }
        run_test!
      end
    end

    put 'Fully update a Rest' do
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :rest, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '200', 'Rest fully updated' do
        let(:id) { Rest.create(name: 'Sample').id }
        let(:rest) { { name: 'Updated Fully' } }
        run_test!
      end

      response '404', 'Rest not found' do
        let(:id) { 'nonexistent' }
        let(:rest) { { name: 'Updated Fully' } }
        run_test!
      end
    end

    delete 'Delete a Rest' do
      parameter name: :id, in: :path, type: :string

      response '204', 'Rest deleted successfully' do
        let(:id) { Rest.create(name: 'Sample').id }
        run_test!
      end

      response '404', 'Rest not found' do
        let(:id) { 'nonexistent' }
        run_test!
      end
    end
  end
end
