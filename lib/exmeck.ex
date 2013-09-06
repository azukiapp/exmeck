defmodule Exmeck do

  # Record def
  Record.deffunctions([module: nil, options: []], __ENV__)
  Record.import __MODULE__, as: :mock

  defoverridable [new: 0]
  def new, do: new(new_module, [])

  defoverridable [new: 1]
  def new(module), do: new(module, [])

  def new(module, options) when is_atom(module) do
    unless is_module?(module) do
      (defmodule module do; end)
      options = List.concat options, [:non_strict]
    end

    # New mock
    :meck.new(module, options)

    mock(module: module, options: options)
  end

  def stubs(func, body, mock(module: module)) do
    :meck.expect(module, func, body)
  end

  def stubs(func, args, return, mock(module: module)) do
    :meck.expect(module, func, args, return)
  end

  def num_calls(func, args, mock(module: module)) do
    :meck.num_calls(module, func, args)
  end

  def destroy!(mock(module: module)) do
    :meck.unload(module)
  end

  # Run
  defmacro mock_run(module // new_module, options // [], contents) do
    quote hygiene: [vars: false] do
      mock = unquote(__MODULE__).new(unquote(module), unquote(options))
      unquote(contents)
      mock.destroy!
    end
  end

  # Helpers
  defp new_module do
    list_to_atom('exmeck-mock-#{:uuid.to_string(:uuid.uuid4())}')
  end

  defp is_module?(module) when !is_atom(module) do; false; end
  defp is_module?(module) do
    try do
      module.module_info; true
    rescue
      _ -> false
    end
  end
end
