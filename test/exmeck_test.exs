defmodule ExmeckTest do
  use ExUnit.Case, async: false
  require Exmeck

  @name_pattern %r/^exmeck-mock-[\w|-]{36}$/

  test "return anonymous mock to new mock" do
    mock = Exmeck.new
    assert is_atom(mock.module)
    assert "#{mock.module}" =~ @name_pattern
  end

  test "auto add :non_strict option for anonymous mock" do
    mock = Exmeck.new
    assert :non_strict in mock.options
  end

  test "module options return a module is mocked" do
    mock = Exmeck.new
    assert "#{mock.module}" =~ @name_pattern

    mock = Exmeck.new URI
    assert mock.module == URI
    mock.destroy!
  end

  test "support to :stub_all" do
    mock = Exmeck.new URI, [stub_all: :ok]
    assert :ok == URI.parse "http://example.com"
    mock.destroy!

    assert "http" == (URI.parse("http://example.com")).scheme
  end

  test "run a function in context of mock" do
    Exmeck.mock_run URI, [stub_all: :ok] do
      assert URI == mock.module
      assert :ok == URI.parse "http://example.com"
    end
    assert "http" == (URI.parse("http://example.com")).scheme
  end

  test "stubs with function" do
    Exmeck.mock_run do
      mock.stubs(:test, fn -> :ok end)
      assert :ok == mock.module.test
    end
  end

  test "stubs with pattern" do
    Exmeck.mock_run do
      mock.stubs(:test, [:_, 2], :ok)
      assert :ok == mock.module.test(:any, 2)
    end
  end
end
