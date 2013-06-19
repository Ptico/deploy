module Deploy
  class Application
    class Paths
      attr_reader :root, :repo, :shared, :releases, :current

      def each(&block)
        enums.each(&block)
      end

    private

      attr_reader :enums

      def initialize(root_path)
        @root     = root_path
        @repo     = root_path.join('git')
        @shared   = root_path.join('shared')
        @releases = root_path.join('releases')
        @current  = root_path.join('current')

        @enums = [repo, shared, releases].freeze
        freeze
      end
    end
  end
end
