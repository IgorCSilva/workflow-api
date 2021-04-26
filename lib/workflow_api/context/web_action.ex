defmodule WorkflowApi.Context.WebAction do

  def redirect_to_thanks_page() do
    %{redirect_to: :thank_you_page}
  end

  def redirect_to_google_page() do
    %{redirect_directly_to: "https://www.google.com.br"}
  end

  def show_thanks_modal() do
    %{show_modal: :thanks_modal}
  end

  def show_guide_modal() do
    %{show_modal: :guide_modal}
  end

end
