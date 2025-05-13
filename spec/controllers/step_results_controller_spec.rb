# frozen_string_literal: true

require 'rails_helper'

describe StepResultsController, type: :controller do
  login_user

  include_context 'reference_project_structure', {
    my_modules: 1,
    step: true,
    result_text: true
  }

  let(:step_second) { create :step, protocol: my_modules.first.protocol, user: user }
  let(:result_second) { create :result, my_module: my_modules.first, user: user }
  let(:step_result) { create :step_result, step: step_second, result:  result_second }

  describe 'POST create link step result succesfully' do
    let(:action) { post :create, params: params }
    let(:params) do
      {
        step_id: step.id,
        result_id: result_text.result.id
      }
    end

    it 'calls create link step result succesfully' do
      expect(Activities::CreateActivityService)
        .to(receive(:call)
        .with(hash_including(activity_type: :task_result_task_protocol_step_linked)))
      action
      expect(response).to have_http_status(:success)
    end

    it 'adds activity in DB' do
      expect { action }
        .to(change { Activity.count })
    end

    it 'calls create link step result unsuccesfully for step and result from different task' do
      params[:step_id] = step_second.id
      action
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE destroy' do
    let(:action) { delete :destroy, params: params, format: :json }

    context 'calls deleting step result' do
      let(:params) { { id: step_result.id } }

      it 'calls create activity for deleting step result' do
        expect(Activities::CreateActivityService)
          .to(receive(:call)
          .with(hash_including(activity_type: :task_result_task_protocol_step_unlinked)))
        action
        expect(response).to have_http_status(:success)
      end

      it 'adds activity in DB' do
        expect { action }
          .to(change { Activity.count })
      end
    end
  end
end
