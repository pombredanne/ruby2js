module Ruby2JS
  class Converter

    # (true)
    # (false)

    handle :true, :false do
      @ast.type.to_s
    end
  end
end
