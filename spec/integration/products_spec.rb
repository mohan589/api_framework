require 'swagger_helper'

RSpec.describe 'Products API', type: :request do
  # GET /products
  path '/products' do
    get 'Retrieve all products' do
      produces 'application/json'
      response '200', 'successful request' do
        run_test!
      end
    end

    post 'Create a new Product' do
      consumes 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '201', 'Product created successfully' do
        let(:product) { { name: 'Test Name' } }
        run_test!
      end
    end
  end

  # GET /products/{id}
  path '/products/{id}' do
    get 'Retrieve a Product by ID' do
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Product found' do
        let(:id) { Product.create(name: 'Sample').id }
        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { 'nonexistent' }
        run_test!
      end
    end

    patch 'Partially update a Product' do
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      response '200', 'Product updated successfully' do
        let(:id) { Product.create(name: 'Sample').id }
        let(:product) { { name: 'Updated' } }
        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { 'nonexistent' }
        let(:product) { { name: 'Updated' } }
        run_test!
      end
    end

    put 'Fully update a Product' do
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '200', 'Product fully updated' do
        let(:id) { Product.create(name: 'Sample').id }
        let(:product) { { name: 'Updated Fully' } }
        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { 'nonexistent' }
        let(:product) { { name: 'Updated Fully' } }
        run_test!
      end
    end

    delete 'Delete a Product' do
      parameter name: :id, in: :path, type: :string

      response '204', 'Product deleted successfully' do
        let(:id) { Product.create(name: 'Sample').id }
        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { 'nonexistent' }
        run_test!
      end
    end
  end
end
