module Ruby2JS
  class Converter

   # (args
   #   (arg :a)
   #   (restarg :b)
   #   (blockarg :c))

    handle :args do |*args|
      args.map { |arg| parse arg }.join(', ')
    end
  end
end
