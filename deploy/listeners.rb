module Deploy
  class Listeners
    include Listenable

    def fire(event, app)
      return unless listener = listeners[event]

      listener.callback.call
    end

  end
end