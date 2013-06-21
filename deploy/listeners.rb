module Deploy
  class Listeners
    include Listenable

    def fire(event, data)
      return unless listener = listeners[event]

      listener.callback.call(data)
    end
  end
end