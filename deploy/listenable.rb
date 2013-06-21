module Deploy
  module Listenable
    Listener = Struct.new(:callback, :options).freeze

    def before(event, *args, &block)
      events << event.to_sym
      add_listener("before_#{event}", *args, &block)
    end

    def on(event, *args, &block)
      events << event.to_sym
      add_listener("on_#{event}", *args, &block)
    end

    def after(event, *args, &block)
      events << event.to_sym
      add_listener("after_#{event}", *args, &block)
    end

    def fire(event, data)
      return unless listener = listeners[event]

      if callback = listener.callback
        instance = self.new
        if callback.is_a?(Symbol)
          instance.send(callback)
        else
          instance.instance_exec(data, &callback)
        end
      end
    end

    def listeners
      @listeners ||= {}
    end

    def events
      @events ||= []
    end

  private

    def add_listener(name, *args, &block)
      options = args.shift if args.last.is_a?(Hash) # Extract options

      callback = block || args.first.to_sym

      listeners[name] = Listener.new(callback, options)
    end

  end
end
